//
//  SignRecognitionScreenVM.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 06.04.2026.
//

import SwiftUI
import CoreImage
import Combine
import Vision
import AVFoundation

class SignRecognitionScreenVM: ObservableObject {
  
  // MARK: - Published State
  @Published var currentFrame: CGImage?
  @Published var handDetected: Bool = false
  @Published var hands: [[String: CGPoint]] = []
  @Published var isTorchOn: Bool = false {
    didSet {
      toggleTorch(on: isTorchOn)
    }
  }
  
  // Classification output
  @Published var recognizedText: String = ""
  @Published var currentLetter: String = ""
  @Published var confidence: Double = 0.0
  
  // MARK: - Private
  private let cameraService = CameraService()
  private let classifier = SignClassifier()
  private let textReducer = RecognizerTextReducer()
  private var predictionStabilizer = PredictionStabilizer()
    
  // Pairs of joints to connect with lines (skeleton)
  static let connectionPairs: [(String, String)] = [
    // Thumb
    ("wrist", "thumbCMC"), ("thumbCMC", "thumbMP"), ("thumbMP", "thumbIP"), ("thumbIP", "thumbTip"),
    // Index
    ("wrist", "indexMCP"), ("indexMCP", "indexPIP"), ("indexPIP", "indexDIP"), ("indexDIP", "indexTip"),
    // Middle
    ("wrist", "middleMCP"), ("middleMCP", "middlePIP"), ("middlePIP", "middleDIP"), ("middleDIP", "middleTip"),
    // Ring
    ("wrist", "ringMCP"), ("ringMCP", "ringPIP"), ("ringPIP", "ringDIP"), ("ringDIP", "ringTip"),
    // Little
    ("wrist", "littleMCP"), ("littleMCP", "littlePIP"), ("littlePIP", "littleDIP"), ("littleDIP", "littleTip"),
  ]
  
  init() {
    Task {
      await handleCameraPreviews()
    }
    Task {
      await handleHandPose()
    }
  }
  
  // MARK: - Lifecycle Controls
  func startCamera() {
    cameraService.start()
  }
  
  func stopCamera() {
    cameraService.stop()
  }
  
  func handleCameraPreviews() async {
    for await image in cameraService.previewStream {
      Task { @MainActor in
        currentFrame = image
      }
    }
  }
  
  func handleHandPose() async {
    for await observations in cameraService.handPoseStream {
      // 1. Extract joint positions for skeleton overlay
      let results = Self.extractAllHands(from: observations)
      
      // 2. Classify the first detected hand
      var label = ""
      var conf = 0.0
      
      if let firstObservation = observations.first,
         let classifier = classifier,
         let result = classifier.classify(firstObservation) {
        label = result.label
        conf = result.confidence
      }
      
      // 2.5 Filter by confidence if setting is enabled
      if AppSettingsService.shared.highConfidenceOnly && conf < 0.9 {
        label = ""
      }
      
      // 3. Process through stability buffer
      let committedLetter = processStabilityBuffer(label: label)
      
      // 4. Update UI on main thread
      Task { @MainActor in
        handDetected = !observations.isEmpty
        hands = results
        
        if !label.isEmpty && label != "nothing" {
          currentLetter = label.uppercased()
          confidence = conf
        } else {
          currentLetter = ""
          confidence = 0.0
        }
        
        // Append committed letter to recognized text
        if let letter = committedLetter {
          applyLetter(letter)
        }
      }
    }
  }
  
  // MARK: - Stability Buffer
  
  /// Adds a prediction to the buffer and returns a committed letter if stable
  private func processStabilityBuffer(label: String) -> String? {
    predictionStabilizer.process(label: label)
  }
  
  // MARK: - Torch
  func toggleTorch(on: Bool) {
    guard let device = AVCaptureDevice.default(for: .video) else { return }
    
    if device.hasTorch {
      do {
        try device.lockForConfiguration()
        device.torchMode = on ? .on : .off
        device.unlockForConfiguration()
      } catch {
        print("Torch could not be used")
      }
    } else {
      print("Torch is not available")
    }
  }
  // MARK: - Text Manipulation
  @MainActor
  private func applyLetter(_ letter: String) {
    recognizedText = textReducer.reduce(text: recognizedText, letter: letter)
    
    if AppSettingsService.shared.hapticFeedbackOn {
      UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
  }
  
  @MainActor
  func clearText() {
    recognizedText = ""
    predictionStabilizer.reset()
  }
  
  /// Extracts all 21 joint points for each detected hand
  private static func extractAllHands(from observations: [VNHumanHandPoseObservation]) -> [[String: CGPoint]] {
    var allHands: [[String: CGPoint]] = []
    
    let jointMap: [(String, VNHumanHandPoseObservation.JointName)] = [
      ("wrist", .wrist),
      ("thumbCMC", .thumbCMC), ("thumbMP", .thumbMP), ("thumbIP", .thumbIP), ("thumbTip", .thumbTip),
      ("indexMCP", .indexMCP), ("indexPIP", .indexPIP), ("indexDIP", .indexDIP), ("indexTip", .indexTip),
      ("middleMCP", .middleMCP), ("middlePIP", .middlePIP), ("middleDIP", .middleDIP), ("middleTip", .middleTip),
      ("ringMCP", .ringMCP), ("ringPIP", .ringPIP), ("ringDIP", .ringDIP), ("ringTip", .ringTip),
      ("littleMCP", .littleMCP), ("littlePIP", .littlePIP), ("littleDIP", .littleDIP), ("littleTip", .littleTip),
    ]
    
    for observation in observations {
      var joints: [String: CGPoint] = [:]
      for (name, jointName) in jointMap {
        guard let point = try? observation.recognizedPoint(jointName),
              point.confidence > 0.3 else { continue }
        joints[name] = CGPoint(x: point.location.x, y: 1 - point.location.y)
      }
      if !joints.isEmpty {
        allHands.append(joints)
      }
    }
    
    return allHands
  }
}

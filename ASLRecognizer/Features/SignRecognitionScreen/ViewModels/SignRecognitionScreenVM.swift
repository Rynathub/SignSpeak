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
  
  // Stability buffer: stores recent predictions
  private var predictionBuffer: [String] = []
  private let bufferSize = 15
  private let stabilityThreshold = 10  // Must appear ≥10 times in buffer to register
  private var lastCommittedLabel: String? = nil
  
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
    // Ignore "nothing" — don't add to buffer, but reset tracking
    guard !label.isEmpty, label != "nothing" else {
      predictionBuffer.removeAll()
      lastCommittedLabel = nil
      return nil
    }
    
    predictionBuffer.append(label)
    
    // Keep buffer at fixed size
    if predictionBuffer.count > bufferSize {
      predictionBuffer.removeFirst()
    }
    
    // Count occurrences of the most frequent label
    let counts = Dictionary(grouping: predictionBuffer, by: { $0 })
      .mapValues { $0.count }
    
    guard let (topLabel, topCount) = counts.max(by: { $0.value < $1.value }),
          topCount >= stabilityThreshold else {
      return nil
    }
    
    guard topLabel != lastCommittedLabel else {
      return nil
    }
    
    lastCommittedLabel = topLabel
    predictionBuffer.removeAll()
    return topLabel
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
    switch letter.lowercased() {
    case "space":
      recognizedText.append(" ")
    case "del":
      if !recognizedText.isEmpty {
        recognizedText.removeLast()
      }
    default:
      recognizedText.append(letter.uppercased())
    }
    
    if AppSettingsService.shared.hapticFeedbackOn {
      UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
  }
  
  @MainActor
  func clearText() {
    recognizedText = ""
    predictionBuffer.removeAll()
    lastCommittedLabel = nil
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

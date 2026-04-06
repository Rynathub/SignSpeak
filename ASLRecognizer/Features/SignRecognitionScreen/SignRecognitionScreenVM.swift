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

class SignRecognitionScreenVM: ObservableObject {
  
  @Published var currentFrame: CGImage?
  @Published var handDetected: Bool = false
  @Published var hands: [[String: CGPoint]] = []
  
  private let cameraService = CameraService()
  
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
  
  func handleCameraPreviews() async {
    for await image in cameraService.previewStream {
      Task { @MainActor in
        currentFrame = image
      }
    }
  }
  
  func handleHandPose() async {
    for await observations in cameraService.handPoseStream {
      let results = Self.extractAllHands(from: observations)
      Task { @MainActor in
        handDetected = !observations.isEmpty
        hands = results
      }
    }
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

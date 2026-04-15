//
//  SignClassifier.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 07.04.2026.
//

import CoreML
import Vision

final class SignClassifier {
  
  // MARK: - Properties
  private let model: ASLHandPoseClassifier_1
  
  // MARK: - Result
  struct ClassificationResult {
    let label: String
    let confidence: Double
  }
  
  // MARK: - Init
  init?() {
    do {
      let config = MLModelConfiguration()
      config.computeUnits = .all
      self.model = try ASLHandPoseClassifier_1(configuration: config)
    } catch {
      print("❌ Failed to initialize ASLHandPoseClassifier: \(error)")
      return nil
    }
  }
  
  // MARK: - Classification
  
  /// Classifies a hand pose observation and returns the predicted ASL letter
  func classify(_ observation: VNHumanHandPoseObservation) -> ClassificationResult? {
    do {
      // Get the keypoints as MLMultiArray — this is exactly what
      // Create ML Hand Pose Classification models expect as input
      let multiArray = try observation.keypointsMultiArray()
      
      // Run prediction
      let prediction = try model.prediction(poses: multiArray)
      
      // Get confidence for the predicted label
      let confidence = prediction.labelProbabilities[prediction.label] ?? 0.0
      
      return ClassificationResult(
        label: prediction.label,
        confidence: confidence
      )
    } catch {
      print("❌ Classification failed: \(error)")
      return nil
    }
  }
}

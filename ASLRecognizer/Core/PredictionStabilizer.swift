//
//  PredictionStabilizer.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 02.05.2026.
//

import Foundation

struct PredictionStabilizer {
  private var buffer: [String] = []
  private let bufferSize = 15
  private let stabilityThreshold = 10  // Must appear ≥10 times in buffer to register
  private var lastCommittedLabel: String? = nil
  
  mutating func process(label: String) -> String? {
    guard !label.isEmpty, label != "nothing" else {
      reset()
      return nil
    }
    buffer.append(label)
    
    if buffer.count > bufferSize {
      buffer.removeFirst()
    }
    
    let counts = Dictionary(grouping: buffer, by: { $0 }).mapValues({ $0.count })
    
    guard let (topLabel, topCount) = counts.max(by: { $0.value < $1.value }),
          topCount >= stabilityThreshold else {
      return nil
    }
    
    guard topLabel != lastCommittedLabel else {
      return nil
    }
    
    lastCommittedLabel = topLabel
    buffer.removeAll()
    return topLabel
  }
  
  mutating func reset() {
    buffer.removeAll()
    lastCommittedLabel = nil
  }
}

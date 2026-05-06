//
//  PredictionStabilizerTests.swift
//  ASLRecognizerTests
//
//  Created by Rynat Shakirov on 02.05.2026.
//

import XCTest
@testable import ASLRecognizer

final class PredictionStabilizerTests: XCTestCase {
  func testOnEmptyLabel() {
    var stabilizer = PredictionStabilizer()

    let result = stabilizer.process(label: "")

    XCTAssertNil(result)
  }
  
  func testCommitsLabelWhenStabilityThresholdIsReached() {
    var stabilizer = PredictionStabilizer()

    for _ in 0..<9 {
      XCTAssertNil(stabilizer.process(label: "A"))
    }
    
    let result = stabilizer.process(label: "A")
    
    XCTAssertEqual(result, "A")
  }
  
  func testDoesNotCommitSameLabelTwiceInARow() {
    var stabilizer = PredictionStabilizer()
    
    for _ in 0..<10 {
      _ = stabilizer.process(label: "A")
    }
    
    let result = stabilizer.process(label: "A")
    
    XCTAssertNil(result)
  }
  
  func testCommitSameLabelAfterReset() {
    var stabilizer = PredictionStabilizer()
    
    var commit: String?
    
    for _ in 0..<10 {
      commit = stabilizer.process(label: "A")
    }
    
    XCTAssertEqual(commit, "A")
    
    let sameLabelResult = stabilizer.process(label: "A")
    XCTAssertNil(sameLabelResult)
    
    stabilizer.reset()
    
    var result: String?
    
    for _ in 0..<10 {
      result = stabilizer.process(label: "A")
    }
    
    XCTAssertEqual(result, "A")
  }
  
  func testNothingLabelResetsState() {
    var stabilizer = PredictionStabilizer()
    var firstCommit: String?

    for _ in 0..<10 {
      firstCommit = stabilizer.process(label: "A")
    }

    XCTAssertEqual(firstCommit, "A")

    XCTAssertNil(stabilizer.process(label: "A"))

    let resetResult = stabilizer.process(label: "nothing")
    XCTAssertNil(resetResult)

    var secondCommit: String?

    for _ in 0..<10 {
      secondCommit = stabilizer.process(label: "A")
    }

    XCTAssertEqual(secondCommit, "A")
  }
  
  func testCanCommitDifferentLabelAfterPreviousCommit() {
    var stabilizer = PredictionStabilizer()
    var firstCommit: String?
    
    for _ in 0..<10 {
      firstCommit = stabilizer.process(label: "A")
    }
    
    XCTAssertEqual(firstCommit, "A")
    XCTAssertNil(stabilizer.process(label: "A"))

    var secondCommit: String?

    for _ in 0..<10 {
      secondCommit = stabilizer.process(label: "B")
    }
    
    XCTAssertEqual(secondCommit, "B")
  }
}

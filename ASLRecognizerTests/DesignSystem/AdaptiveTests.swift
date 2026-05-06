//
//  AdaptiveTests.swift
//  ASLRecognizerTests
//
//  Created by Rynat Shakirov on 02.05.2026.
//

import XCTest
@testable import ASLRecognizer

final class AdaptiveTests: XCTestCase {
  
  func testScaleForStandardDevice() {
    let device: AdaptiveDeviceCategory = .standard
    
    let scale = Adaptive.scale(device: device)
    
    XCTAssertEqual(scale, 1.0)
  }
  
  func testScaleForProDevice() {
    
    let device: AdaptiveDeviceCategory = .plus
    
    let scale = Adaptive.scale(device: device)
    
    XCTAssertEqual(scale, 1.8)
    
  }
}

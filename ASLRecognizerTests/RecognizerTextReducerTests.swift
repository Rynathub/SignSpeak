//
//  RecognizerTextReducerTests.swift
//  ASLRecognizerTests
//
//  Created by Rynat Shakirov on 02.05.2026.
//

import XCTest
@testable import ASLRecognizer

final class RecognizerTextReducerTests: XCTestCase {
  
  func testUpperCaseLetters() {
    let text = "B"
    let letter = "A"
    let reducer = RecognizerTextReducer()
    
    let result = reducer.reduce(text: text, letter: letter)
    
    XCTAssertEqual(result, "BA")
  }
  
  func testLowerCaseLetters() {
    let text = "B"
    let letter = "a"
    let reducer = RecognizerTextReducer()
    
    let result = reducer.reduce(text: text, letter: letter)
    
    XCTAssertEqual(result, "BA")
  }
  
  func testSpaceGesture() {
    let text = "AG"
    let letter = "space"
    let reducer = RecognizerTextReducer()
    
    let result = reducer.reduce(text: text, letter: letter)
    
    XCTAssertEqual(result, "AG ")
  }
  
  func testDelGesture() {
    let text = "AG"
    let letter = "del"
    let reducer = RecognizerTextReducer()
    
    let result = reducer.reduce(text: text, letter: letter)
    
    XCTAssertEqual(result, "A")
  }
  
  func testDelGestureOnEmptyText() {
    let text = ""
    let letter = "del"
    let reducer = RecognizerTextReducer()
    
    let result = reducer.reduce(text: text, letter: letter)
    
    XCTAssertEqual(result, "")
  }
  
  func testUppercaseSpaceGestureAddsSpacer() {
    let text = "AG"
    let letter = "SPACE"
    let reducer = RecognizerTextReducer()
    
    let result = reducer.reduce(text: text, letter: letter)
    
    XCTAssertEqual(result, "AG ")
  }
}


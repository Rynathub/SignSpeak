//
//  RecognizerTextReducer.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 02.05.2026.
//

import Foundation

struct RecognizerTextReducer {
  func reduce(text: String, letter: String) -> String {
    switch letter.lowercased() {
    case "space":
      return text + " "
    case "del":
      return String(text.dropLast())
    default: return text + letter.uppercased()
    }
  }
}

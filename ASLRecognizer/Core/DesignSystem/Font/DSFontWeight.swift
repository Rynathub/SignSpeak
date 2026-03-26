//
//  DSFontWeight.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 27.03.2026.
//

import Foundation

public enum DSFontWeight {
  case regular, semibold
  
  public var fontName: String {
    switch self {
    case .regular: "Inter-Regula"
    case .semibold: "Inter-SemiBold"
    }
  }
}

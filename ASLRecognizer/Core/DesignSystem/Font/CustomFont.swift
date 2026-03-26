//
//  CustomFont.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 27.03.2026.
//

import Foundation
import SwiftUI

public extension Font {
  static func inter(weight: DSFontWeight = .regular, size: CGFloat) -> Font {
    customFont(name: weight.fontName, size: size)
  }
  
  fileprivate static func customFont(name: String, size: CGFloat) -> Font {
      guard let uiFont = UIFont(name: name, size: size) else {
          return Font.system(size: size)
      }
      return Font(uiFont)
  }
}

//
//  ButtonsStyle.swift
//  ASLRecognizer
//

import Foundation
import SwiftUI

extension DSButton {
  
  enum ButtonsStyle {
    case primary, secondary, text
    
    var textColor: Color {
      switch self {
      case .primary: .white
      case .secondary: .black
      case .text: .primary
      }
    }
    
    var backgroundStyle: AnyShapeStyle {
      switch self {
      case .primary:
        return AnyShapeStyle(Color.brandBlue)
      case .secondary:
        return AnyShapeStyle(Color.white)
      case .text:
        return AnyShapeStyle(Color.clear)
      }
    }
  }
}

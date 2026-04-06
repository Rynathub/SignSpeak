//
//  AdaptiveUI.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 27.03.2026.
//

import Foundation
import UIKit

public enum AdaptiveDeviceCategory {
  case compact
  case compactTall
  case standard
  case pro
  case plus
  case proMax
  
  public static var current: AdaptiveDeviceCategory {
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    let width = windowScene?.screen.bounds.width ?? 390
    let height = windowScene?.screen.bounds.height ?? 844
    
    switch width {
    case ..<380:
      if height < 700 {
        return .compact  // SE 2/3 (667 height)
      } else {
        return .compactTall  // 12/13 mini (812 height)
      }
    case 380..<400:
      return .standard
    case 400..<410:
      return .pro
    case 410..<435:
      return .plus
    default:
      return .proMax
    }
  }
}

public struct Adaptive {
  public static func adaptive(_ standardValue: CGFloat) -> CGFloat {
    let scale = Self.scale(device: AdaptiveDeviceCategory.current)
    return (standardValue * scale).rounded()
  }
  
  public static func scale(device: AdaptiveDeviceCategory) -> CGFloat {
    switch device {
    case .compact, .compactTall: 0.92
    case .standard: 1.0
    case .pro: 1.1
    case .plus, .proMax: 1.8
    }
  }
}

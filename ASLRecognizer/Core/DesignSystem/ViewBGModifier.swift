//
//  Stroke&ShadowModifier.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 05.04.2026.
//

import SwiftUI

enum ViewBGStyle {
  case bigShadow
  case smallShadow
}

struct ViewBGModifier: ViewModifier {
  let style: ViewBGStyle
  
  func body(content: Content) -> some View {
    content
      .background {
        background(style)
      }
  }
  
  @ViewBuilder private func background(_ style: ViewBGStyle) -> some View {
    switch style {
    case .smallShadow:
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(Color.white)
        .overlay {
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .stroke(Color.black.opacity(0.08), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.10),
                radius: 3,
                x: 0,
                y: 1)
        .shadow(color: .black.opacity(0.10),
                radius: 2,
                x: 0,
                y: 1)
    case .bigShadow:
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(Color.white)
        .overlay {
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .stroke(Color.black.opacity(0.04), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.10),
                radius: 15,
                x: 0,
                y: 10)
        .shadow(color: .black.opacity(0.10),
                radius: 6,
                x: 0,
                y: 4)
    }
  }
}

extension View {
  func viewBG(_ style: ViewBGStyle = .smallShadow) -> some View {
    modifier(ViewBGModifier(style: style))
  }
}

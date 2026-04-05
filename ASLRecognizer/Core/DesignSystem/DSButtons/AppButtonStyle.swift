//
//  PrimaryButtonStyle.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 27.03.2026.
//

import Foundation
import SwiftUI

enum AppButtonVariant {
  case primary
  case secondary
  case text
}

enum AppButtonWidth {
  case fit
  case full
}

struct AppButtonStyle: ButtonStyle {
  let variant: AppButtonVariant
  let width: AppButtonWidth
  
  @Environment(\.isEnabled) private var isEnabled
  
  init(variant: AppButtonVariant, width: AppButtonWidth = .full) {
    self.variant = variant
    self.width = width
  }
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.inter(weight: .semibold, size: Adaptive.adaptive(16)))
      .foregroundStyle(foregroundColor)
      .frame(maxWidth: width == .full ? .infinity : nil)
      .padding(.vertical, verticalPadding)
      .padding(.horizontal, horizontalPadding)
      .background {
        background(isPressed: configuration.isPressed)
      }
      .scaleEffect(scale(isPressed: configuration.isPressed))
      .offset(y: offsetY(isPressed: configuration.isPressed))
      .opacity(isEnabled ? 1 : 0.5)
      .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
  }
  
  private var verticalPadding: CGFloat {
    switch variant {
    case .text:
      return 0
    case .primary, .secondary:
      return Adaptive.adaptive(12)
    }
  }
  
  private var horizontalPadding: CGFloat {
    switch variant {
    case .text:
      return 0
    case .primary, .secondary:
      return Adaptive.adaptive(24)
    }
  }
  
  private var foregroundColor: Color {
    switch variant {
    case .primary:
        .white
    case .secondary:
        .black
    case .text:
        .brandBlue
    }
  }
  
  @ViewBuilder
  private func background(isPressed: Bool) -> some View {
    switch variant {
    case .primary:
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(Color.blue)
        .shadow(color: Color.blue.opacity(0.25),
                radius: isPressed ? 7 : 15,
                x: 0,
                y: isPressed ? 5 : 10)
        .shadow(color: Color.blue.opacity(0.25),
                radius: isPressed ? 3 : 6,
                x: 0,
                y: isPressed ? 2 : 4)
      
    case .secondary:
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(Color.white)
        .overlay {
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .stroke(Color.black.opacity(0.08), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.10),
                radius: isPressed ? 1 : 3,
                x: 0,
                y: isPressed ? 0 : 1)
        .shadow(color: .black.opacity(0.10),
                radius: isPressed ? 1 : 2,
                x: 0,
                y: isPressed ? 0 : 1)
      
    case .text:
      Color.clear
    }
  }
  
  private func scale(isPressed: Bool) -> CGFloat {
    switch variant {
    case .primary, .secondary:
      return isPressed ? 0.985 : 1
    case .text:
      return isPressed ? 0.97 : 1
    }
  }
  
  private func offsetY(isPressed: Bool) -> CGFloat {
    switch variant {
    case .primary, .secondary:
      return isPressed ? 1 : 0
    case .text:
      return 0
    }
  }
  
}

extension ButtonStyle where Self == AppButtonStyle {
  static var myAppPrimaryButton: AppButtonStyle { .init(variant: .primary) }
  static var myAppSecondaryButton: AppButtonStyle { .init(variant: .secondary) }
  static var myAppTextButton: AppButtonStyle { .init(variant: .text) }
}

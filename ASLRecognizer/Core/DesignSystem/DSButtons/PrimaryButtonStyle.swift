//
//  PrimaryButtonStyle.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 27.03.2026.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundStyle(Color.white)
      .padding(.vertical, 12)
      .padding(.horizontal, 24)
      .background {
        Color.brandBlue
      }
  }
}

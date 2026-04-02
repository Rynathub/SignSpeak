//
//  AppScreenBGModifier.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 03.04.2026.
//

import SwiftUI

struct AppScreenBGModifier: ViewModifier {
  let color: Color
  
  func body(content: Content) -> some View {
    ZStack {
      color
        .ignoresSafeArea()
      content
    }
  }
}

extension View {
  func appScreenBG(_ color: Color = .brandRichWhite) -> some View {
    modifier(AppScreenBGModifier(color: color))
  }
}

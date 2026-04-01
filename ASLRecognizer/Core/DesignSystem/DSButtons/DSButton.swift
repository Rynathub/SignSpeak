//
//  DSButton.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 22.03.2026.
//

import SwiftUI

struct DSButton<Label:View>: View {
  let style: AppButtonVariant
  let label: () -> Label
  let action: () -> Void
  
    var body: some View {
      Button(action: action) {
        label()
      }
      .buttonStyle(AppButtonStyle(variant: style))
    }
}

#Preview {
  VStack(spacing: 36) {    
    DSButton(style: .primary) {
      Text("Get Started")
    } action: {}
    
    DSButton(style: .secondary) {
      Text("Get Started")
    } action: {}
    
    DSButton(style: .text) {
      Text("Get Started")
    } action: {}
  }
}

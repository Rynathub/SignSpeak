//
//  DSButton.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 22.03.2026.
//

import SwiftUI

struct DSButton<Label:View>: View {
  let style: AppButtonVariant
  let width: AppButtonWidth
  let label: () -> Label
  let action: () -> Void
  
    var body: some View {
      Button(action: action) {
        label()
      }
      .buttonStyle(AppButtonStyle(variant: style, width: width))
    }
}

#Preview {
  VStack(spacing: 36) {    
    DSButton(style: .primary, width: .fit) {
      Text("Get Started")
    } action: {}
    
    DSButton(style: .secondary, width: .full) {
      Text("Get Started")
    } action: {}
    
    DSButton(style: .text, width: .fit) {
      Text("Get Started")
    } action: {}
  }
}

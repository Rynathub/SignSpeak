//
//  DSButton.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 22.03.2026.
//

import SwiftUI

struct DSButton: View {
  let style: ButtonsStyle
  let onTap: () -> Void
  
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
  DSButton(style: .primary, onTap: {})
}

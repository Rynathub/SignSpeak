//
//  DSInformationSection.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 22.03.2026.
//

import SwiftUI

enum InformationSectionStyle {
  case proTips
  case warning
  
  var themeColor: Color {
    switch self {
    case .proTips: return .orange
    case .warning: return .red
    }
  }
  
  var icon: String {
    switch self {
    case .proTips: return "lightbulb"
    case .warning: return "exclamationmark.circle"
    }
  }
}

struct DSInformationSection: View {
  let style: InformationSectionStyle
  let title: String
  let content: InformationContent
  
  enum InformationContent {
    case list([String])
    case text(String)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: Adaptive.adaptive(16)) {
      // Header
      HStack(spacing: Adaptive.adaptive(12)) {
        ZStack {
          Circle()
            .fill(style.themeColor)
          Image(systemName: style.icon)
            .resizable()
            .scaledToFit()
            .foregroundStyle(.white)
            .frame(width: Adaptive.adaptive(20), height: Adaptive.adaptive(20))
        }
        .frame(width: Adaptive.adaptive(40), height: Adaptive.adaptive(40))
        
        Text(title)
          .font(.inter(weight: .semibold, size: Adaptive.adaptive(18)))
          .foregroundStyle(.black)
      }
      
      // Content
      Group {
        switch content {
        case .list(let items):
          VStack(alignment: .leading, spacing: Adaptive.adaptive(14)) {
            ForEach(items, id: \.self) { item in
              HStack(alignment: .top, spacing: Adaptive.adaptive(10)) {
                Circle()
                  .fill(style.themeColor)
                  .frame(width: 7, height: 7)
                  .padding(.top, 7)
                Text(item)
                  .font(.inter(weight: .regular, size: Adaptive.adaptive(15)))
                  .foregroundStyle(.black.opacity(0.75))
                  .lineSpacing(2)
              }
            }
          }
        case .text(let text):
          Text(text)
            .font(.inter(weight: .regular, size: Adaptive.adaptive(15)))
            .foregroundStyle(.gray6)
            .lineSpacing(4)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(Adaptive.adaptive(20))
    .background {
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .fill(style.themeColor.opacity(0.08))
    }
  }
}

#Preview {
  VStack(spacing: 20) {
    DSInformationSection(
      style: .proTips,
      title: "Pro Tips",
      content: .list([
        "Use good lighting for better recognition accuracy",
        "Keep your hand movements slow and deliberate"
      ])
    )
    
    DSInformationSection(
      style: .warning,
      title: "Educational Prototype",
      content: .text("This is a demonstration app showcasing sign language recognition technology. The gesture library is limited and results may vary.")
    )
  }
  .padding()
}

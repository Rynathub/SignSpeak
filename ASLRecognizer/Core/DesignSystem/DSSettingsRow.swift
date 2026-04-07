//
//  DSSettingsRow.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 08.04.2026.
//

import SwiftUI

// MARK: - Row Style

enum DSSettingsRowStyle {
  case toggle(isOn: Binding<Bool>)
  case navigation
  case info
}

// MARK: - Component

struct DSSettingsRow: View {
  let icon: ImageResource
  let iconColor: Color
  let title: String
  var subtitle: String? = nil
  let style: DSSettingsRowStyle
  var action: (() -> Void)? = nil
  
  var body: some View {
    switch style {
    case .navigation:
      Button {
        action?()
      } label: {
        rowContent
      }
      .buttonStyle(.plain)
      
    default:
      rowContent
    }
  }
  
  // MARK: - Row Content
  
  private var rowContent: some View {
    HStack(spacing: Adaptive.adaptive(12)) {
      // Icon
      iconView
      
      // Title + Subtitle
      VStack(alignment: .leading, spacing: 3) {
        Text(title)
          .font(.inter(weight: .semibold, size: Adaptive.adaptive(16)))
          .foregroundStyle(.black)
        
        if let subtitle {
          Text(subtitle)
            .font(.inter(weight: .regular, size: Adaptive.adaptive(13)))
            .foregroundStyle(.gray6)
        }
      }
      
      Spacer(minLength: 4)
      
      // Accessory (right side)
      accessoryView
    }
    .padding(.horizontal, Adaptive.adaptive(12))
    .padding(.vertical, Adaptive.adaptive(14))
  }
  
  // MARK: - Icon
  
  private var iconView: some View {
    Image(icon)
      .resizable()
      .renderingMode(.template)
      .foregroundStyle(iconColor)
      .frame(
        width: Adaptive.adaptive(20),
        height: Adaptive.adaptive(20)
      )
      .padding(Adaptive.adaptive(6))
      .background {
        RoundedRectangle(cornerRadius: Adaptive.adaptive(12), style: .continuous)
          .fill(iconColor.opacity(0.1))
      }
  }
  
  // MARK: - Accessory
  
  @ViewBuilder
  private var accessoryView: some View {
    switch style {
    case .toggle(let isOn):
      Toggle("", isOn: isOn)
        .labelsHidden()
        .tint(.brandBlue)
        .fixedSize()
      
    case .navigation:
      Image(systemName: "chevron.right")
        .font(.system(size: 13, weight: .semibold))
        .foregroundStyle(.gray6.opacity(0.4))
      
    case .info:
      EmptyView()
    }
  }
}

// MARK: - Settings Section (grouping helper)

struct DSSettingsSection<Content: View>: View {
  let title: String
  @ViewBuilder let content: () -> Content
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(title.uppercased())
        .font(.inter(weight: .semibold, size: Adaptive.adaptive(12)))
        .foregroundStyle(.gray6)
        .padding(.bottom, Adaptive.adaptive(8))
      
      VStack(spacing: 0) {
        content()
      }
      .background {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .fill(.white)
      }
      .viewBG(.bigShadow)
    }
  }
}

// MARK: - Preview

#Preview {
  ScrollView {
    VStack(spacing: Adaptive.adaptive(24)) {
      DSSettingsSection(title: "Recognition") {
        DSSettingsRow(
          icon: .icHand,
          iconColor: .brandBlue,
          title: "Show Hands Skeleton",
          subtitle: "Display joint overlay on camera",
          style: .toggle(isOn: .constant(true))
        )
        
        Divider()
        
        DSSettingsRow(
          icon: .icCamera,
          iconColor: .brandBlue,
          title: "High Confidence Only",
          subtitle: "Only show results with 90%+ confidence",
          style: .toggle(isOn: .constant(false))
        )
      }
      
      DSSettingsSection(title: "About") {
        DSSettingsRow(
          icon: .icHelp,
          iconColor: .brandBlue,
          title: "Help & Tutorial",
          style: .navigation
        ) {
          print("Navigate to tutorial")
        }
        
        Divider()
        
        DSSettingsRow(
          icon: .icSuccess,
          iconColor: .brandBlue,
          title: "About SignSpeak",
          subtitle: "Version 1.0.0",
          style: .info
        )
      }
    }
    .padding(16)
  }
  .background(Color(.systemGroupedBackground))
}

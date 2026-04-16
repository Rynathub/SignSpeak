//
//  SettingsItem.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 08.04.2026.
//

import SwiftUI


struct SettingsItem: View {
  
  enum DSSettingsItemStyle {
    case toggle(isOn: Binding<Bool>)
    case info
    case navigation
  }
  
  let style: DSSettingsItemStyle
  let icon: ImageResource
  let title: LocalizedStringKey
  let subTitle: LocalizedStringKey?
  let action: (() -> Void)
  
  var body: some View {
    contentView
  }
  
  @ViewBuilder
  private var contentView: some View {
      Button(action: action) {
        HStack(spacing: Adaptive.adaptive(12)) {
          imageView
          textView
          Spacer(minLength: 4)
          trailingContent
        }
      }
  }
  
  private var textView: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(title)
        .font(.inter(weight: .semibold, size: Adaptive.adaptive(14)))
        .foregroundStyle(.black)
        .multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true)
      if let subTitle = subTitle {
        Text(subTitle)
          .font(.inter(weight: .regular, size: Adaptive.adaptive(12)))
          .foregroundStyle(.gray6)
          .multilineTextAlignment(.leading)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
  }
  
  @ViewBuilder
  private var trailingContent: some View {
    switch style {
    case .toggle(let isOn):
      Toggle("", isOn: isOn)
        .labelsHidden()
        .tint(.brandBlue)
        .fixedSize()
    case .info:
      EmptyView()
    case .navigation:
      Image(systemName: "chevron.right")
        .font(.system(size: Adaptive.adaptive(16), weight: .medium))
        .foregroundStyle(.gray6)
    }
  }
  
  private var imageView: some View {
    Image(icon)
      .renderingMode(.original)
      .resizable()
      .frame(width: Adaptive.adaptive(20), height: Adaptive.adaptive(20))
      .padding(Adaptive.adaptive(6))
      .background {
        RoundedRectangle(cornerRadius: 14)
          .fill(Color.brandBlue.opacity(0.1))
      }
  }
}

#Preview {
  @Previewable @State var isOn: Bool = false
  VStack(spacing: 16) {
    SettingsItem(style: .toggle(isOn: $isOn), icon: .icCamera, title: "Camera", subTitle: "Subtitle here", action: {})
    SettingsItem(style: .info, icon: .icCamera, title: "Camera", subTitle: "Subtitle hereSubtitle hereSubtitle hereSubtitle here", action: {})
    
    SettingsItem(style: .navigation, icon: .icCamera, title: "Camera", subTitle: "Subtitle here", action: {})
  }
  .padding()
}

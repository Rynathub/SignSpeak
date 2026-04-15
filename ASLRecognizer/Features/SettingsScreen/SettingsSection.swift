//
//  SettingsSection.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 08.04.2026.
//

import SwiftUI

struct SettingsSection: View {
  let title: String
  let settingsItems: [SettingsItem]
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(title.uppercased())
        .font(.inter(weight: .semibold, size: Adaptive.adaptive(13)))
        .foregroundStyle(.gray6)
      VStack(spacing: Adaptive.adaptive(8)) {
        ForEach(Array(settingsItems.enumerated()), id: \.offset) { index, item in
          item
          if index != settingsItems.count - 1 {
            Divider()
              .padding(.vertical, Adaptive.adaptive(12))
          }
        }
      }
      .padding(Adaptive.adaptive(16))
      .viewBG(.smallShadow)
    }
  }
}

#Preview {
  @Previewable @State var isOn: Bool = false
  SettingsSection(
    title: "Camera", settingsItems:
      [
        SettingsItem(style: .toggle(isOn: $isOn), icon: .icCamera, title: "Camera", subTitle: "Subtitle here", action: {}),
        SettingsItem(style: .info, icon: .icCamera, title: "Camera", subTitle: "Subtitle hereSubtitle hereSubtitle hereSubtitle hereSubtitle here", action: {}),
        SettingsItem(style: .navigation, icon: .icCamera, title: "Camera", subTitle: "Subtitle here", action: {})
      ]
  )
  .padding()
}

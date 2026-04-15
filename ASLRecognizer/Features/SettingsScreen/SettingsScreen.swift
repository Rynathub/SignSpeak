//
//  SettingsScreen.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 07.04.2026.
//

import SwiftUI

struct SettingsScreen: View {
  @Binding var isPresented: Bool
  @EnvironmentObject var appSettingsService: AppSettingsService
  @StateObject private var viewModel = SettingsScreenVM()
  @State var isOn: Bool = false
  @State private var showTutorial = false
  
  var body: some View {
    ScrollView {
      VStack(spacing: Adaptive.adaptive(24)) {
        SettingsSection(title: "Recognition", settingsItems: [
          SettingsItem(style: .toggle(isOn: $appSettingsService.showHandsOverlay), icon: .icHand, title: "Hand Overlay", subTitle: "Will draw 2D overlay over your hand", action: { appSettingsService.showHandsOverlay.toggle()}),
          SettingsItem(style: .toggle(isOn: $appSettingsService.highConfidenceOnly), icon: .icCamera, title: "High Confidence Only", subTitle: "Only show results with 90%+ confidence", action: { appSettingsService.highConfidenceOnly.toggle()})

        ])
        
        SettingsSection(title: "Feedback", settingsItems:[
          SettingsItem(style: .toggle(isOn: $appSettingsService.hapticFeedbackOn), icon: .icHaptic, title: "Haptic Feedback", subTitle: nil, action: { appSettingsService.hapticFeedbackOn.toggle()}),
        ])
        
        SettingsSection(title: "Appearance", settingsItems:[
          SettingsItem(style: .navigation, icon: .icLanguage, title: "Language", subTitle: "English", action: {}),
        ])
        
        SettingsSection(title: "About", settingsItems:[
          SettingsItem(style: .navigation, icon: .icHelp, title: "Help & Tutorial", subTitle: nil, action: { showTutorial = true }),
          SettingsItem(style: .info, icon: .icAlert, title: "About SignSpeak", subTitle: "Version \(appSettingsService.appVersion)", action: {})
        ])
        Text("SignSpeak is designed to help bridge communication gaps. Please note this is a demonstration app with limited gesture recognition capabilities.")
          .font(.inter(weight: .regular, size: Adaptive.adaptive(13)))
          .multilineTextAlignment(.center)
          .foregroundStyle(.gray6)
      }
      .padding(Adaptive.adaptive(16))
    }
    .appScreenBG(.gray1)
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          isPresented = false
        } label: {
          Image(systemName: "chevron.left")
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(.black)
        }
      }
      ToolbarItem(placement: .principal) {
        Text("Settings")
          .font(.inter(weight: .semibold, size: Adaptive.adaptive(18)))
          .foregroundStyle(.black)
      }
    }
    .navigationDestination(isPresented: $showTutorial) {
      TutorialScreen(onStartAction: {
        showTutorial = false
        isPresented = false
      })
    }
  }
}

#Preview {
  SettingsScreen(isPresented: .constant(true))
    .environmentObject(AppSettingsService.shared)
}

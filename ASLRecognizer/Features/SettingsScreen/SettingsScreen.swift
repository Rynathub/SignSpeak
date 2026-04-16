//
//  SettingsScreen.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 07.04.2026.
//

import SwiftUI

struct SettingsScreen: View {
  @Binding var isPresented: Bool
  var onStartRecognizing: (() -> Void)? = nil
  @EnvironmentObject var appSettingsService: AppSettingsService
  @StateObject private var viewModel = SettingsScreenVM()
  @State var isOn: Bool = false
  @State private var showTutorial = false
  @State private var showLanguageSheet = false
  
  private var currentLanguageTitle: LocalizedStringKey {
    switch appSettingsService.appLanguage {
    case "en": return "English"
    case "uk": return "Українська"
    default: return "System Default"
    }
  }
  
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
          SettingsItem(style: .navigation, icon: .icLanguage, title: "Language", subTitle: currentLanguageTitle, action: { showLanguageSheet = true }),
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
        if let action = onStartRecognizing {
          action()
        } else {
          showTutorial = false
          isPresented = false
        }
      })
    }
    .sheet(isPresented: $showLanguageSheet) {
      LanguageSelectionSheet(isPresented: $showLanguageSheet)
        .presentationDetents([.height(250)])
        .presentationDragIndicator(.visible)
    }
  }
}

struct LanguageSelectionSheet: View {
  @Binding var isPresented: Bool
  @EnvironmentObject var appSettingsService: AppSettingsService
  
  var body: some View {
    VStack(spacing: Adaptive.adaptive(20)) {
      Text("Language")
        .font(.inter(weight: .semibold, size: 20))
        .padding(.top, 24)
        .padding(.bottom, 8)
      
      VStack(spacing: 0) {
        languageRow(title: "English", value: "en")
        Divider()
        languageRow(title: "Українська", value: "uk")
      }
      .background {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .fill(Color.gray.opacity(0.08))
      }
      .padding(.horizontal, Adaptive.adaptive(24))
      
      Spacer()
    }
  }
  
  private func languageRow(title: LocalizedStringKey, value: String) -> some View {
    Button {
      appSettingsService.appLanguage = value
      isPresented = false
    } label: {
      HStack {
        Text(title)
          .font(.inter(weight: .semibold, size: 16))
          .foregroundStyle(.black)
        Spacer()
        if appSettingsService.appLanguage == value {
          Image(systemName: "checkmark")
            .foregroundStyle(Color.blue)
            .font(.system(size: 16, weight: .bold))
        }
      }
      .padding(.vertical, Adaptive.adaptive(16))
      .padding(.horizontal, Adaptive.adaptive(20))
      .contentShape(Rectangle())
    }
  }
}

#Preview {
  SettingsScreen(isPresented: .constant(true))
    .environmentObject(AppSettingsService.shared)
}

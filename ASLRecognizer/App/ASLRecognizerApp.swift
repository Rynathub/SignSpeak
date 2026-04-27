//
//  ASLRecognizerApp.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 09.03.2026.
// Test push for CI/CD

import SwiftUI

@main
struct ASLRecognizerApp: App {
  @StateObject private var settingsService = AppSettingsService.shared
  
  var body: some Scene {
    WindowGroup {
      AppRootView()
        .environmentObject(settingsService)
    }
  }
}

struct AppRootView: View {
  @EnvironmentObject var settingsService: AppSettingsService
  @State private var showGetStarted = true
  
  var body: some View {
    SignRecognitionScreen()
      .preferredColorScheme(.light)
      .fullScreenCover(isPresented: $showGetStarted) {
        GetStartedScreen {
          withAnimation(.easeInOut(duration: 0.4)) {
            showGetStarted = false
          }
        }
        .preferredColorScheme(.light)
      }
      .environment(\.locale, settingsService.appLanguage.isEmpty ? .current : Locale(identifier: settingsService.appLanguage))
  }
}

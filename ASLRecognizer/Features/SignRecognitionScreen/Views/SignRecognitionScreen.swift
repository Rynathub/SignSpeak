//
//  SignRecognitionScreen.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 05.04.2026.
//

import SwiftUI

struct SignRecognitionScreen: View {
  @StateObject private var viewModel = SignRecognitionScreenVM()

  @State private var showTutorial = false
  @State private var showSettings = false
  
    var body: some View {
      NavigationStack {
        contentView
          .appScreenBG(.gray1)
          .navigationDestination(isPresented: $showTutorial) {
            TutorialScreen()
          }
          .toolbar(.hidden, for: .navigationBar)
          .navigationDestination(isPresented: $showSettings, destination: {
            SettingsScreen()
          })
          .toolbar(.hidden, for: .navigationBar)
      }
    }
  
  private var contentView: some View {
    VStack(spacing: 0) {
      SignRecognitionHeader(showTutorial: $showTutorial, showSettings: $showSettings)
        .zIndex(1)
      Spacer()
      SignRecognitionCameraSection(viewModel: viewModel)
        .padding(.bottom, Adaptive.adaptive(16))
      SignRecognitionOutputCard(viewModel: viewModel)
      Spacer()
      SignRecognitionBottomButtons(viewModel: viewModel)
    }
  }
}

#Preview {
    SignRecognitionScreen()
}

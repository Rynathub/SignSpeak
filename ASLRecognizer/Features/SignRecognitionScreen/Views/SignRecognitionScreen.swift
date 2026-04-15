//
//  SignRecognitionScreen.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 05.04.2026.
//

import SwiftUI

struct SignRecognitionScreen: View {
  @Environment(\.scenePhase) private var scenePhase
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
            SettingsScreen(isPresented: $showSettings)
          })
          .toolbar(.hidden, for: .navigationBar)
      }
      .onAppear {
        updateCameraState()
      }
      .onChange(of: showSettings) { _ in updateCameraState() }
      .onChange(of: showTutorial) { _ in updateCameraState() }
      .onChange(of: scenePhase) { newPhase in
        if newPhase == .active {
          updateCameraState()
        } else {
          viewModel.stopCamera()
        }
      }
    }
    
  private func updateCameraState() {
    if showSettings || showTutorial {
      viewModel.stopCamera()
    } else {
      viewModel.startCamera()
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

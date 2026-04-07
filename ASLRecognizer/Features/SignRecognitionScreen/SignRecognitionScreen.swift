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
      header
        .zIndex(1)
      Spacer()
      cameraSection
        .padding(.bottom, Adaptive.adaptive(16))
      outputCard
      Spacer()
      bottomButtons
    }
  }
  
  private var header: some View {
    HStack() {
      DSButton(style: .text, width: .fit) {
        Image(.icHelp)
          .resizable()
          .frame(width: 24, height: 24)
      } action: { showTutorial = true }
      Spacer()
      DSButton(style: .text, width: .fit) {
        Image(.icSettings)
          .resizable()
          .frame(width: 24, height: 24)
      } action: { showSettings = true }
    }
    .padding(.horizontal, Adaptive.adaptive(24))
    .padding(.bottom, Adaptive.adaptive(12))
    .background {
      Color.white
        .ignoresSafeArea()
    }
  }
  
  private var cameraSection: some View {
    CameraView(
      image: $viewModel.currentFrame,
      hands: viewModel.hands,
      connectionPairs: SignRecognitionScreenVM.connectionPairs
    )
    .overlay(alignment: .topTrailing) {
      if !viewModel.currentLetter.isEmpty {
        Text(viewModel.currentLetter)
          .font(.inter(weight: .semibold, size: Adaptive.adaptive(28)))
          .foregroundStyle(.white)
          .padding(.horizontal, Adaptive.adaptive(14))
          .padding(.vertical, Adaptive.adaptive(8))
          .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
              .fill(LinearGradient.primaryGradient)
          }
          .padding(Adaptive.adaptive(12))
          .transition(.scale.combined(with: .opacity))
          .animation(.easeInOut(duration: 0.2), value: viewModel.currentLetter)
      }
    }
    .padding(.horizontal, Adaptive.adaptive(16))
  }
  
  private var outputCard: some View {
    VStack(alignment: .leading, spacing: Adaptive.adaptive(12)) {
      HStack {
        Text("Recognized Text")
          .font(.inter(weight: .semibold, size: 15))
          .foregroundStyle(.gray6)
        Spacer()
        if !viewModel.recognizedText.isEmpty {
          Button {
            viewModel.clearText()
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundStyle(.gray6.opacity(0.4))
              .font(.system(size: 20))
          }
        }
      }
      Text(viewModel.recognizedText.isEmpty ? "Waiting for gestures..." : viewModel.recognizedText)
        .foregroundStyle(viewModel.recognizedText.isEmpty ? .gray6.opacity(0.5) : .black)
        .font(.inter(weight: .regular, size: 16))
        .frame(maxWidth: .infinity, alignment: .leading)
        .multilineTextAlignment(.leading)
        .animation(.easeInOut(duration: 0.15), value: viewModel.recognizedText)
    }
    .padding(Adaptive.adaptive(20))
    .padding(.bottom, Adaptive.adaptive(5))
    .background {
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .fill(.white)
        .viewBG(.bigShadow)
    }
    .padding(.horizontal, Adaptive.adaptive(16))
  }
  
  private var bottomButtons: some View {
    HStack(spacing: Adaptive.adaptive(12)) {
      DSButton(style: .secondary, width: .full) {
        HStack {
          Text("Speak Aloud")
            .font(.inter(weight: .semibold, size: Adaptive.adaptive(16)))
        }
      } action: {}
        .disabled(viewModel.recognizedText.isEmpty)

      DSButton(style: .secondary, width: .full) {
        HStack {
          Image(.icHistory)
            .renderingMode(.template)
            .resizable()
            .frame(width: 20, height: 20)
          Text("History")
        }
      } action: {}
    }
    .padding(.horizontal, Adaptive.adaptive(16))
  }
}

#Preview {
    SignRecognitionScreen()
}

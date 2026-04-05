//
//  SignRecognitionScreen.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 05.04.2026.
//

import SwiftUI

struct SignRecognitionScreen: View {
  @State private var isButtonDisabled = true
  @State private var text: String = "dasdasdaadsdasdasdhjsadahdashddnasdjhasjhd"
  
    var body: some View {
      contentView
      .appScreenBG(.gray1)
    }
  
  private var contentView: some View {
    VStack() {
      header
      Spacer()
      cameraSection
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
      } action: {
        
      }
      Spacer()
      DSButton(style: .text, width: .fit) {
        Image(.icSettings)
          .resizable()
          .frame(width: 24, height: 24)
      } action: {
        
      }
    }
    .padding(.horizontal, Adaptive.adaptive(24))
    .padding(.bottom, Adaptive.adaptive(12))
    .background {
      Color.white
        .ignoresSafeArea()
    }
  }
  
  private var cameraSection: some View {
    RoundedRectangle(cornerRadius: 24)
      .frame(width: 375,height: 450)
      .padding()
  }
  
  private var outputCard: some View {
    VStack(alignment: .leading, spacing: Adaptive.adaptive(12)) {
      Text("Recognized Text")
        .font(.inter(weight: .semibold, size: 15))
        .foregroundStyle(.gray6)
      Text(text.isEmpty ? "Waiting for gestures..." : text)
        .foregroundStyle(.gray6)
        .font(.inter(weight: .regular, size: 16))
        .frame(maxWidth: .infinity, alignment: .leading)
        .multilineTextAlignment(.leading)
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
        .disabled(isButtonDisabled)

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

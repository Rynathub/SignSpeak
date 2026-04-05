//
//  GetStartedScreen.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 03.04.2026.
//

import SwiftUI

struct GetStartedScreen: View {
  var body: some View {
    contentView
  }
  
  private var contentView: some View{
    VStack(spacing: 0) {
      logoView
      textView
        .padding(.top, Adaptive.adaptive(24))
      featuresView
        .padding(.top, Adaptive.adaptive(20))
      
      Spacer()
      buttonsView
    }
  }
  
  private var logoView: some View {
    
    Image(.icHand)
      .renderingMode(.template)
      .resizable()
      .frame(width: Adaptive.adaptive(48),height: Adaptive.adaptive(48) )
      .foregroundStyle(.white)
      .padding(Adaptive.adaptive(24))
      .background {
        RoundedRectangle(cornerRadius: Adaptive.adaptive(28))
          .fill(LinearGradient.primaryGradient)
      }
  }
  
  private var textView: some View {
    VStack(spacing: Adaptive.adaptive(12)) {
      Text("SignSpeak")
        .font(.inter(weight: .semibold, size: Adaptive.adaptive(32)))
        .foregroundStyle(.black)
      Text("Bridge the communication gap\n with real-time sign language\n recognition")
        .font(.inter(weight: .regular, size: Adaptive.adaptive(16)))
        .foregroundStyle(.gray6)
        .multilineTextAlignment(.center)
        .lineSpacing(3)
    }
  }
  
  private var featuresView: some View {
    VStack(spacing: Adaptive.adaptive(12)) {
      FeatureView(title: "Real-Time Recognition", subTitle: "Instant gesture-to-text conversion", image: .icHand)
      FeatureView(title: "Conversation History", subTitle: "Review and share past conversations", image: .icConversation)
      FeatureView(title: "Accessible & Inclusive", subTitle: "Built for everyone to communicate", image: .icHeart)
    }
    .padding(.horizontal, Adaptive.adaptive(24))
  }
  
  private var buttonsView: some View {
    VStack(spacing: Adaptive.adaptive(15)) {
      DSButton(style: .primary, width: .full) {
        Text("Get Started")
      } action: {
        
      }
      HStack() {
        DSButton(style: .text, width: .full) {
          Text("How it works?")
            .font(.inter(weight: .semibold, size: Adaptive.adaptive(14)))
        } action: {}
        DSButton(style: .text, width: .full) {
          Text("Settings")
            .font(.inter(weight: .semibold, size: Adaptive.adaptive(14)))
        } action: {}
      }
    }
    .padding(.horizontal, Adaptive.adaptive(16))
  }
}

#Preview {
  GetStartedScreen()
}

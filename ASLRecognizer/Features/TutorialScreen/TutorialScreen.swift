//
//  TutorialScreen.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 07.04.2026.
//

import SwiftUI

struct TutorialScreen: View {
  @Environment(\.dismiss) private var dismiss
  var onStartAction: (() -> Void)? = nil
  
  var body: some View {
    VStack(spacing: 0) {
      ScrollView(showsIndicators: false) {
        VStack(spacing: Adaptive.adaptive(16)) {
          headerSection
          
          stepsSection
          
          proTipsSection
          
          warningSection
            .padding(.bottom, Adaptive.adaptive(8))
          bottomCTA
        }
        .padding(.horizontal, Adaptive.adaptive(16))
      }
    }
    .appScreenBG(.gray1)
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          dismiss()
        } label: {
          Image(systemName: "chevron.left")
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(.black)
        }
      }
      ToolbarItem(placement: .principal) {
        Text("Help & Tutorial")
          .font(.inter(weight: .semibold, size: Adaptive.adaptive(18)))
          .foregroundStyle(.black)
      }
    }
  }
  
  // MARK: - Header
  private var headerSection: some View {
    VStack(spacing: Adaptive.adaptive(12)) {
      // Icon
      Image(.icHand)
        .renderingMode(.template)
        .resizable()
        .frame(width: Adaptive.adaptive(40), height: Adaptive.adaptive(40))
        .foregroundStyle(.white)
        .padding(Adaptive.adaptive(18))
        .background {
          RoundedRectangle(cornerRadius: Adaptive.adaptive(24), style: .continuous)
            .fill(LinearGradient.primaryGradient)
        }
      
      // Title
      Text("How to Use SignSpeak")
        .font(.inter(weight: .semibold, size: Adaptive.adaptive(24)))
        .foregroundStyle(.black)
      
      // Subtitle
      Text("Follow these simple steps to start communicating with sign language")
        .font(.inter(weight: .regular, size: Adaptive.adaptive(14)))
        .foregroundStyle(.gray6)
        .multilineTextAlignment(.center)
        .padding(.horizontal, Adaptive.adaptive(16))
    }
    .padding(.bottom, Adaptive.adaptive(8))
  }
  
  // MARK: - Steps
  private var stepsSection: some View {
    VStack(spacing: Adaptive.adaptive(12)) {
      TutorialStepView(
        stepNumber: 1,
        title: "Position Your Hand",
        description: "Hold your hand in front of the camera within the detection frame. Make sure your hand is well-lit and clearly visible.",
        icon: .icCamera,
        iconColor: .brandBlue
      )
      
      TutorialStepView(
        stepNumber: 2,
        title: "Make a Gesture",
        description: "Perform a sign language gesture slowly and clearly. The app will analyze your hand movements in real-time.",
        icon: .icHand,
        iconColor: .orange
      )
      
      TutorialStepView(
        stepNumber: 3,
        title: "View Recognition",
        description: "The recognized text will appear instantly below the camera. Use the speak button to hear it aloud or save to history.",
        icon: .icSuccess,
        iconColor: .green
      )
    }
  }
  
  // MARK: - Information Sections
  private var proTipsSection: some View {
    DSInformationSection(
      style: .proTips,
      title: "Pro Tips",
      content: .list([
        "Use good lighting for better recognition accuracy",
        "Keep your hand movements slow and deliberate",
        "Center your hand within the detection frame",
        "Avoid cluttered or busy backgrounds",
        "Practice common gestures for faster communication"
      ])
    )
    .padding(.top, Adaptive.adaptive(8))
  }
  
  private var warningSection: some View {
    DSInformationSection(
      style: .warning,
      title: "Educational Prototype",
      content: .text("This is a demonstration app showcasing sign language recognition technology. The gesture library is limited and results may vary. For comprehensive communication, please consult with professional sign language interpreters.")
    )
    .padding(.top, Adaptive.adaptive(8))
  }
  
  // MARK: - Bottom CTA
  private var bottomCTA: some View {
    VStack(spacing: 0) {
      DSButton(style: .primary, width: .full) {
        Text("Start Recognizing")
          .font(.inter(weight: .semibold, size: 16))
      } action: {
        if let action = onStartAction {
          action()
        } else {
          dismiss()
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    TutorialScreen()
  }
}

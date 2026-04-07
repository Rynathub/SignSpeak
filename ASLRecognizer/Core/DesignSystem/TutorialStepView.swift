//
//  TutorialStepView.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 07.04.2026.
//

import SwiftUI

struct TutorialStepView: View {
  let stepNumber: Int
  let title: String
  let description: String
  let icon: ImageResource
  let iconColor: Color
  
  var body: some View {
    HStack(alignment: .top, spacing: Adaptive.adaptive(14)) {
      // Icon
      VStack(spacing: Adaptive.adaptive(8)) {
        ZStack {
          RoundedRectangle(cornerRadius: Adaptive.adaptive(16), style: .continuous)
            .fill(iconColor)
          Image(icon)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.white)
            .frame(width: Adaptive.adaptive(24), height: Adaptive.adaptive(24))
        }
        .frame(width: Adaptive.adaptive(48), height: Adaptive.adaptive(48))
        Text("\(stepNumber)")
          .font(.inter(weight: .semibold, size: Adaptive.adaptive(28)))
          .foregroundStyle(.gray6.opacity(0.3))
      }
      // Text content
      VStack(alignment: .leading, spacing: Adaptive.adaptive(6)) {
        Text(title)
          .font(.inter(weight: .semibold, size: Adaptive.adaptive(16)))
          .foregroundStyle(.black)
        Text(description)
          .font(.inter(weight: .regular, size: Adaptive.adaptive(14)))
          .foregroundStyle(.gray6)
          .lineSpacing(3)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(Adaptive.adaptive(16))
    .padding(.bottom, Adaptive.adaptive(4))
    .background {
      RoundedRectangle(cornerRadius: 20, style: .continuous)
        .fill(.white)
    }
    .viewBG(.bigShadow)
  }
}

#Preview {
  VStack(spacing: 16) {
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
  }
  .padding(16)
}

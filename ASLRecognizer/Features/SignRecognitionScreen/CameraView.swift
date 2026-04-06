//
//  CameraView.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 06.04.2026.
//

import SwiftUI

struct CameraView: View {
  @Binding var image: CGImage?
  
  var body: some View {
    GeometryReader { geometry in
      if let image = image {
        Image(decorative: image, scale: 1)
          .resizable()
          .frame(width: geometry.size.width,
                 height: geometry.size.height)
          .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
      } else {
        ZStack {
          RoundedRectangle(cornerRadius: 24)
          VStack(alignment: .center, spacing: Adaptive.adaptive(12)) {
            Image(.icCameraDenied)
              .resizable()
              .renderingMode(.original)
              .frame(width: 56, height: 56)
            Text("Camera Access Required")
              .font(.inter(weight: .semibold, size: Adaptive.adaptive(18)))
              .foregroundStyle(.white)
            Text("Please enable camera permission to use sign language recognition")
              .font(.inter(weight: .regular, size: Adaptive.adaptive(14)))
              .multilineTextAlignment(.center)
              .foregroundStyle(.white.opacity(0.7))
            DSButton(style: .primary, width: .fit) {
              Text("Retry")
                .font(.inter(weight: .semibold, size: Adaptive.adaptive(16)))
            } action: {}
          }
        }
      }
    }
  }
}

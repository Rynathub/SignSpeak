//
//  FeatureView.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 22.03.2026.
//

import SwiftUI

struct FeatureView: View {
  let title: String
  let subTitle: String
  let image: ImageResource
  
  var body: some View {
    featureView
  }
  
  private var featureView: some View {
    HStack(alignment: .top, spacing: Adaptive.adaptive(16)) {
      trailingImageView
      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.inter(weight: .semibold, size: Adaptive.adaptive(18)))
          .foregroundStyle(.black)
        Text(subTitle)
          .font(.inter(weight: .regular, size: Adaptive.adaptive(15)))
          .foregroundStyle(.gray6)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(Adaptive.adaptive(16))
    .background {
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(Color.white)
        .overlay {
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .stroke(Color.black.opacity(0.08), lineWidth: 1)
        }
    }
    .shadow(color: .black.opacity(0.10),
            radius: 3,
            x: 0,
            y: 1)
    .shadow(color: .black.opacity(0.10),
            radius: 2,
            x: 0,
            y: 1)
  }
  
  private var trailingImageView: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .fill(.brandBlue.opacity(0.10))
      Image(image)
        .resizable()
        .renderingMode(.original)
        .frame(width: Adaptive.adaptive(24), height: Adaptive.adaptive(24))
        .padding(12)
    }
    .frame(width: Adaptive.adaptive(48), height: Adaptive.adaptive(48))
  }
}

#Preview {
  VStack {
    FeatureView(title: "Test", subTitle: "Subtitle ", image: .icHand)
    FeatureView(title: "Test", subTitle: "Subtitle SubtitleSubtitleSubtitleSubtitle SubtitleSubtitleSubtitle", image: .icHand)
    FeatureView(title: "Test", subTitle: "Subt", image: .icHand)
    FeatureView(title: "Test", subTitle: "Subtitle SubtitleSubtitleSubtitle", image: .icHand)
  }.padding(6)
}

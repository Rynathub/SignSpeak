////
////  SettingsItem.swift
////  ASLRecognizer
////
////  Created by Rynat Shakirov on 08.04.2026.
////
//
//import SwiftUI
//
//
//struct SettingsItem: View {
//  
//  enum DSSettingsItemStyle {
//    case toggle(isOn: Binding<Bool>)
//    case info
//    case navigation
//  }
//  
//  let style: DSSettingsItemStyle
//  let icon: ImageResource
//  let title: String
//  let subTitle: String?
//  let action: (() -> Void)?
//  
//  var body: some View {
//  
//  }
//  
//  private var contentView: some View {
//    if case .navigation = style, let action = action {
//      Button(action: action) {
//        HStack(spacing: Adaptive.adaptive(6)) {
//          imageView
//          textView
//          trailingContent
//        }
//      }
//    }
//  }
//  
//  private var textView: some View {
//    VStack(alignment: .leading, spacing: 2) {
//      Text(title)
//        .font(.inter(weight: .semibold, size: Adaptive.adaptive(16)))
//        .foregroundStyle(.black)
//      if let subTitle = subTitle {
//        Text(subTitle)
//          .font(.inter(weight: .regular, size: Adaptive.adaptive(14)))
//          .foregroundStyle(.gray6)
//      }
//    }
//  }
//  
//  @ViewBuilder
//  private var trailingContent: some View {
//    switch style {
//    case .toggle(let isOn):
//      Toggle("", isOn: isOn)
//        .tint(.brandBlue)
//    case .info:
//      EmptyView()
//    case .navigation:
//      Image(systemName: "chevron.right")
//        .font(.system(size: Adaptive.adaptive(20), weight: .medium))
//        .foregroundStyle(.gray6)
//    }
//  }
//  
//  private var imageView: some View {
//    Image(icon)
//      .renderingMode(.original)
//      .resizable()
//      .frame(width: Adaptive.adaptive(20), height: Adaptive.adaptive(20))
//      .padding(Adaptive.adaptive(6))
//      .background {
//        RoundedRectangle(cornerRadius: 14)
//          .fill(Color.brandBlue.opacity(0.1))
//      }
//  }
//}
//
//#Preview {
//  @Previewable @State var isOn: Bool = false
//  SettingsItem(style: .toggle(isOn: $isOn), icon: .icCamera, title: "Camera", subTitle: "Subtitle here", action: nil)
//}

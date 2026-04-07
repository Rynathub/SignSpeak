//
//  ASLRecognizerApp.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 09.03.2026.
//

import SwiftUI

@main
struct ASLRecognizerApp: App {
  @State private var showGetStarted = true
  
  var body: some Scene {
    WindowGroup {
      SignRecognitionScreen()
        .preferredColorScheme(.light)
        .fullScreenCover(isPresented: $showGetStarted) {
          GetStartedScreen {
            withAnimation(.easeInOut(duration: 0.4)) {
              showGetStarted = false
            }
          }
          .preferredColorScheme(.light)
        }
    }
  }
}

//
//  SignRecognitionScreenVM.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 06.04.2026.
//

import SwiftUI
import CoreImage
import Combine

class SignRecognitionScreenVM: ObservableObject {
  
  @Published var currentFrame: CGImage?
  private let cameraService = CameraService()
  
  init() {
    Task {
     await handleCameraPreviews()
    }
  }
  
  func handleCameraPreviews() async {
    for await image in cameraService.previewStream {
      Task { @MainActor in
        currentFrame = image
      }
    }
  }
}

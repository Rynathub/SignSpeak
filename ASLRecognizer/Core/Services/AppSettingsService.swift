//
//  AppSettingsService.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 15.04.2026.
//

import Combine
import SwiftUI

class AppSettingsService: ObservableObject {
  static let shared = AppSettingsService()
  
  @AppStorage("showHandsOverlay") var showHandsOverlay = false
  @AppStorage("hapticFeedbackOn") var hapticFeedbackOn = false
  @AppStorage("highConfidenceOnly") var highConfidenceOnly = false
  
  let appVersion = UIApplication.appVersion ?? "5.0.0"
  
  private init() {}
}

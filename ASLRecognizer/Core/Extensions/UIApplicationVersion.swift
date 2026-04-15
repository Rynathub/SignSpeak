//
//  UIApplicationVersion.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 15.04.2026.
//

import UIKit

extension UIApplication {
  static var appVersion: String? {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
  }
}

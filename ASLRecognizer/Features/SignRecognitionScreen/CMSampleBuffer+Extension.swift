//
//  CMSampleBuffer+Extension.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 06.04.2026.
//

import Foundation
import CoreMedia
import CoreImage

extension CMSampleBuffer {
  
  private static let ciContext = CIContext()
  
  var cgImage: CGImage? {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(self) else {
      return nil
    }
    
    let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
    return Self.ciContext.createCGImage(ciImage, from: ciImage.extent)
  }
}

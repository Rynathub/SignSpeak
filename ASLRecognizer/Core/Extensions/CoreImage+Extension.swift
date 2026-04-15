//
//  CoreImage+Extension.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 06.04.2026.
//

import CoreImage

extension CIImage {
  
  var cgImage: CGImage? {
    let ciContext = CIContext()
    
    guard let cgImage = ciContext.createCGImage(self, from: self.extent) else {
      return nil
    }
    
    return cgImage
  }
}

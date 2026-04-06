//
//  CameraService.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 06.04.2026.
//

import Foundation
import AVFoundation
import CoreImage

class CameraService: NSObject {
  private let captureSession = AVCaptureSession()
  private var deviceInput: AVCaptureDeviceInput?
  private let systemPreferredCamera = AVCaptureDevice.default(for: .video)
  private var sessionQueue = DispatchQueue(label: "video.preview.session")
  
  private var isAuthorized: Bool {
    get async {
      let status = AVCaptureDevice.authorizationStatus(for: .video)
      
      // Determine if the user previously authorized camera access.
      var isAuthorized = status == .authorized
      
      // If the system hasn't determined the user's authorization status,
      // explicitly prompt them for approval.
      if status == .notDetermined {
        isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
      }
      
      return isAuthorized
    }
  }
  
  private var addToPreviewStream: ((CGImage) -> Void)?
  
  lazy var previewStream: AsyncStream<CGImage> = {
    AsyncStream { continuation in
      addToPreviewStream = { cgImage in
        continuation.yield(cgImage)
      }
    }
  }()
  
  
  override init() {
    super.init()
    
    Task {
      await configureSession()
      await startSession()
    }
  }
  
  private func configureSession() async {
    guard await isAuthorized,
          let systemPreferredCamera,
          let deviceInput = try? AVCaptureDeviceInput(device: systemPreferredCamera)
    else { return }
    
    captureSession.beginConfiguration()
    
    defer {
      self.captureSession.commitConfiguration()
    }
    
    let videoOutput = AVCaptureVideoDataOutput()
    videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
    
    guard captureSession.canAddInput(deviceInput) else {
      print("Unable to add device input to capture session.")
      return
    }
    
    guard captureSession.canAddOutput(videoOutput) else {
      print("Unable to add video output to capture session.")
      return
    }
    
    captureSession.addInput(deviceInput)
    captureSession.addOutput(videoOutput)
    
    if let connection = videoOutput.connection(with: .video) {
        if #available(iOS 17.0, *) {
            if connection.isVideoRotationAngleSupported(90) {
                connection.videoRotationAngle = 90
            }
        } else {
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = .portrait
            }
        }
    }
  }
  
  private func startSession() async {
    guard await isAuthorized else { return }
    Task.detached {
      await self.captureSession.startRunning()
    }
  }
}

extension CameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let currentFrame = sampleBuffer.cgImage else { return }
    addToPreviewStream?(currentFrame)
  }
}

//
//  CameraService.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 06.04.2026.
//

import Foundation
import AVFoundation
import CoreImage
import Vision

class CameraService: NSObject {
  private let captureSession = AVCaptureSession()
  private var deviceInput: AVCaptureDeviceInput?
  private let systemPreferredCamera = AVCaptureDevice.default(for: .video)
  private var sessionQueue = DispatchQueue(label: "video.preview.session")
  
  // MARK: - Hand Pose Detection
  private let handPoseRequest: VNDetectHumanHandPoseRequest = {
    let request = VNDetectHumanHandPoseRequest()
    request.maximumHandCount = 2
    return request
  }()
  
  private var isAuthorized: Bool {
    get async {
      let status = AVCaptureDevice.authorizationStatus(for: .video)
      
      var isAuthorized = status == .authorized
      
      if status == .notDetermined {
        isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
      }
      
      return isAuthorized
    }
  }
  
  // MARK: - Streams
  private var addToPreviewStream: ((CGImage) -> Void)?
  
  lazy var previewStream: AsyncStream<CGImage> = {
    AsyncStream { continuation in
      addToPreviewStream = { cgImage in
        continuation.yield(cgImage)
      }
    }
  }()
  
  private var addToHandPoseStream: (([VNHumanHandPoseObservation]) -> Void)?
  
  lazy var handPoseStream: AsyncStream<[VNHumanHandPoseObservation]> = {
    AsyncStream { continuation in
      addToHandPoseStream = { observations in
        continuation.yield(observations)
      }
    }
  }()
  
  override init() {
    super.init()
    
    Task {
      await configureSession()
    }
  }
  
  // MARK: - Public Controls
  
  func start() {
    guard !captureSession.isRunning else { return }
    sessionQueue.async {
      self.captureSession.startRunning()
    }
  }
  
  func stop() {
    guard captureSession.isRunning else { return }
    sessionQueue.async {
      self.captureSession.stopRunning()
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
}

extension CameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    // 1. Send frame to preview
    guard let currentFrame = sampleBuffer.cgImage else { return }
    addToPreviewStream?(currentFrame)
    
    // 2. Run hand pose detection
    let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
    do {
      try handler.perform([handPoseRequest])
      let observations = handPoseRequest.results ?? []
      addToHandPoseStream?(observations)
    } catch {
      print("Vision hand pose request failed: \(error)")
    }
  }
}

//
//  LaunchScreen.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 02.04.2026.
//

import SwiftUI

struct LaunchScreen<RootView: View, Logo: View>: Scene {
  var config: LaunchScreenConfig = .init()
  @ViewBuilder var logo: () -> Logo
  @ViewBuilder var rootContent: RootView
  
  var body: some Scene {
    WindowGroup {
      rootContent
        .modifier(LaunchScreenModifier(config: config, logo: logo))
    }
  }
  
  fileprivate struct LaunchScreenModifier<LogoView: View>: ViewModifier {
    var config: LaunchScreenConfig
    @ViewBuilder var logo: () -> LogoView
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var splashWindow: UIWindow?
    
    func body(content: Content) -> some View {
      content
        .onAppear {
          let scenes = UIApplication.shared.connectedScenes
          
          for scene in scenes {
            guard let windowScene = scene as? UIWindowScene,
                  checkStates(windowScene.activationState) else {
              continue
            }
            
            // Check if splash already exists for this scene
            if windowScene.windows.contains(where: { $0.tag == 1009 }) {
              print("[LaunchScreen] Already have a splash window for this scene")
              continue
            }
            
            let window = UIWindow(windowScene: windowScene)
            window.tag = 1009
            window.backgroundColor = .clear
            window.windowLevel = .statusBar + 1 // Ensure it is above everything
            window.isHidden = false
            window.isUserInteractionEnabled = true
            
            let rootViewController = UIHostingController(rootView: LaunchScreenView(config: config) {
              logo()
            })
            rootViewController.view.backgroundColor = .clear
            window.rootViewController = rootViewController
            
            self.splashWindow = window
            print("[LaunchScreen] Splash Window Added")
            
            // Departure Logic
            let totalDelay = config.initialDelay + 1.0 // Buffer for entry animation
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay) {
              UIView.animate(withDuration: config.animationDuration, delay: 0, options: .curveEaseOut, animations: {
                window.alpha = 0
                window.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
              }) { _ in
                window.isHidden = true
                window.windowScene = nil
                if self.splashWindow == window {
                  self.splashWindow = nil
                }
                print("[LaunchScreen] Splash Window Dismissed")
              }
            }
          }
        }
    }
    
    private func checkStates(_ state: UIWindowScene.ActivationState) -> Bool {
      switch scenePhase {
      case .background:
        return state == .background
      case .inactive:
        return state == .foregroundInactive
      case .active:
        return state == .foregroundActive
      default: return state.hashValue == scenePhase.hashValue
      }
    }
  }
}

struct LaunchScreenConfig {
  var initialDelay: Double = 1.0
  var backgroundColor: Color = .black
  var logoBackgroundColor: LinearGradient = LinearGradient.primaryGradient
  var logoSize: CGFloat = 120
  var animationDuration: CGFloat = 0.6
}

fileprivate struct LaunchScreenView<Logo: View>: View {
  var config: LaunchScreenConfig
  @ViewBuilder var logo: Logo
  
  @State private var scale: CGFloat = 0.8
  @State private var opacity: Double = 0
  
  var body: some View {
    ZStack {
      config.backgroundColor.ignoresSafeArea()
      
      logo
        .aspectRatio(contentMode: .fit)
        .frame(width: config.logoSize, height: config.logoSize)
        .scaleEffect(scale)
        .opacity(opacity)
    }
    .onAppear {
      withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
        scale = 1.0
        opacity = 1.0
      }
    }
  }
}

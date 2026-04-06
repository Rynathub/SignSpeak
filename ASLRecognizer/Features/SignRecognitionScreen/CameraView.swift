//
//  CameraView.swift
//  ASLRecognizer
//
//  Created by Rynat Shakirov on 06.04.2026.
//

import SwiftUI

struct CameraView: View {
  @Binding var image: CGImage?
  var hands: [[String: CGPoint]]
  var connectionPairs: [(String, String)]
  
  var body: some View {
    GeometryReader { geometry in
      if let image = image {
        ZStack {
          // Camera feed
          Image(decorative: image, scale: 1)
            .resizable()
            .scaledToFill()
            .frame(width: geometry.size.width,
                   height: geometry.size.height)
            .clipped()
          
          // Hand skeleton overlay
          Canvas { context, size in
            let dotColor = Color.green
            let lineColor = Color.green.opacity(0.7)
            let tipColor = Color.yellow
            let dotRadius: CGFloat = 5
            let tipRadius: CGFloat = 7
            
            let tipNames: Set<String> = ["thumbTip", "indexTip", "middleTip", "ringTip", "littleTip"]
            
            for handJoints in hands {
              // Draw connection lines
              for (from, to) in connectionPairs {
                guard let fromPoint = handJoints[from],
                      let toPoint = handJoints[to] else { continue }
                
                let p1 = CGPoint(x: fromPoint.x * size.width, y: fromPoint.y * size.height)
                let p2 = CGPoint(x: toPoint.x * size.width, y: toPoint.y * size.height)
                
                var path = Path()
                path.move(to: p1)
                path.addLine(to: p2)
                context.stroke(path, with: .color(lineColor), lineWidth: 2.5)
              }
              
              // Draw joint dots
              for (name, point) in handJoints {
                let screenPoint = CGPoint(x: point.x * size.width, y: point.y * size.height)
                let isTip = tipNames.contains(name)
                let radius = isTip ? tipRadius : dotRadius
                let color = isTip ? tipColor : dotColor
                
                let rect = CGRect(
                  x: screenPoint.x - radius,
                  y: screenPoint.y - radius,
                  width: radius * 2,
                  height: radius * 2
                )
                context.fill(Path(ellipseIn: rect), with: .color(color))
                
                // White border
                context.stroke(Path(ellipseIn: rect), with: .color(.white.opacity(0.8)), lineWidth: 1.5)
              }
            }
          }
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
      } else {
        ZStack {
          RoundedRectangle(cornerRadius: 24)
          VStack(alignment: .center, spacing: Adaptive.adaptive(12)) {
            Image(.icCameraDenied)
              .resizable()
              .renderingMode(.original)
              .frame(width: 56, height: 56)
            Text("Camera Access Required")
              .font(.inter(weight: .semibold, size: Adaptive.adaptive(18)))
              .foregroundStyle(.white)
            Text("Please enable camera permission to use sign language recognition")
              .font(.inter(weight: .regular, size: Adaptive.adaptive(14)))
              .multilineTextAlignment(.center)
              .foregroundStyle(.white.opacity(0.7))
            DSButton(style: .primary, width: .fit) {
              Text("Retry")
                .font(.inter(weight: .semibold, size: Adaptive.adaptive(16)))
            } action: {}
          }
        }
      }
    }
  }
}

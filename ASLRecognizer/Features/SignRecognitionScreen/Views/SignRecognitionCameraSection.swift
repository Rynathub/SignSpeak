import SwiftUI

struct SignRecognitionCameraSection: View {
  @ObservedObject var viewModel: SignRecognitionScreenVM
  
  var body: some View {
    CameraView(
      image: $viewModel.currentFrame,
      hands: viewModel.hands,
      connectionPairs: SignRecognitionScreenVM.connectionPairs,
      showOverlay: AppSettingsService.shared.showHandsOverlay
    )
    .overlay(alignment: .topTrailing) {
      if !viewModel.currentLetter.isEmpty {
        Text(viewModel.currentLetter)
          .font(.inter(weight: .semibold, size: Adaptive.adaptive(28)))
          .foregroundStyle(.white)
          .padding(.horizontal, Adaptive.adaptive(14))
          .padding(.vertical, Adaptive.adaptive(8))
          .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
              .fill(LinearGradient.primaryGradient)
          }
          .padding(Adaptive.adaptive(12))
          .transition(.scale.combined(with: .opacity))
          .animation(.easeInOut(duration: 0.2), value: viewModel.currentLetter)
      }
    }
    .padding(.horizontal, Adaptive.adaptive(16))
  }
}

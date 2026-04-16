import SwiftUI

struct SignRecognitionBottomButtons: View {
  @ObservedObject var viewModel: SignRecognitionScreenVM
  @State private var didCopy = false
  
  var body: some View {
    HStack(spacing: Adaptive.adaptive(12)) {
      DSButton(style: .secondary, width: .full) {
        HStack {
          Image(systemName: didCopy ? "checkmark" : "doc.on.doc")
            .font(.system(size: 16, weight: .semibold))
          Text(didCopy ? "Copied" : "Copy")
            .font(.inter(weight: .semibold, size: Adaptive.adaptive(16)))
        }
      } action: {
        guard !viewModel.recognizedText.isEmpty else { return }
        UIPasteboard.general.string = viewModel.recognizedText
        if AppSettingsService.shared.hapticFeedbackOn {
          UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        
        withAnimation { didCopy = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          withAnimation { didCopy = false }
        }
      }
      .disabled(viewModel.recognizedText.isEmpty)

      DSButton(style: .destructiveSecondary, width: .full) {
        HStack {
          Image(systemName: "trash")
            .font(.system(size: 16, weight: .semibold))
          Text("Clear")
            .font(.inter(weight: .semibold, size: Adaptive.adaptive(16)))
        }
      } action: {
        viewModel.clearText()
        if AppSettingsService.shared.hapticFeedbackOn {
          UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
      }
      .disabled(viewModel.recognizedText.isEmpty)
    }
    .padding(.horizontal, Adaptive.adaptive(16))
  }
}

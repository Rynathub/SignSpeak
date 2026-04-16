import SwiftUI

struct SignRecognitionOutputCard: View {
  @ObservedObject var viewModel: SignRecognitionScreenVM
  
  var body: some View {
    VStack(alignment: .leading, spacing: Adaptive.adaptive(12)) {
      HStack {
        Text("Recognized Text")
          .font(.inter(weight: .semibold, size: 15))
          .foregroundStyle(.gray6)
        Spacer()
      }
      Text(viewModel.recognizedText.isEmpty ? "Waiting for gestures..." : viewModel.recognizedText)
        .foregroundStyle(viewModel.recognizedText.isEmpty ? .gray6.opacity(0.5) : .black)
        .font(.inter(weight: .regular, size: 16))
        .frame(maxWidth: .infinity, alignment: .leading)
        .multilineTextAlignment(.leading)
        .animation(.easeInOut(duration: 0.15), value: viewModel.recognizedText)
    }
    .padding(Adaptive.adaptive(20))
    .padding(.bottom, Adaptive.adaptive(5))
    .background {
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .fill(.white)
        .viewBG(.bigShadow)
    }
    .padding(.horizontal, Adaptive.adaptive(16))
  }
}

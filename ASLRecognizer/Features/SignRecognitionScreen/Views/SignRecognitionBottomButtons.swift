import SwiftUI

struct SignRecognitionBottomButtons: View {
  @ObservedObject var viewModel: SignRecognitionScreenVM
  
  var body: some View {
    HStack(spacing: Adaptive.adaptive(12)) {
      DSButton(style: .secondary, width: .full) {
        HStack {
          Text("Speak Aloud")
            .font(.inter(weight: .semibold, size: Adaptive.adaptive(16)))
        }
      } action: {}
        .disabled(viewModel.recognizedText.isEmpty)

      DSButton(style: .secondary, width: .full) {
        HStack {
          Image(.icHistory)
            .renderingMode(.template)
            .resizable()
            .frame(width: 20, height: 20)
          Text("History")
        }
      } action: {}
    }
    .padding(.horizontal, Adaptive.adaptive(16))
  }
}

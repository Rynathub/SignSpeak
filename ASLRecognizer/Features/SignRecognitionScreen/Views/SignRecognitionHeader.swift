import SwiftUI

struct SignRecognitionHeader: View {
  @Binding var showTutorial: Bool
  @Binding var showSettings: Bool
  
  var body: some View {
    HStack() {
      DSButton(style: .text, width: .fit) {
        Image(.icHelp)
          .resizable()
          .frame(width: 24, height: 24)
      } action: { showTutorial = true }
      Spacer()
      DSButton(style: .text, width: .fit) {
        Image(.icSettings)
          .resizable()
          .frame(width: 24, height: 24)
      } action: { showSettings = true }
    }
    .padding(.horizontal, Adaptive.adaptive(24))
    .padding(.bottom, Adaptive.adaptive(12))
    .background {
      Color.white
        .ignoresSafeArea()
    }
  }
}

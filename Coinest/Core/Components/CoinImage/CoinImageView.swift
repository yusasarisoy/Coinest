import SwiftUI

struct CoinImageView: View {
  // MARK: - Properties
  @StateObject private var coinImageViewModel: CoinImageViewModel

  // MARK: - Initialization
  init(coin: Coin) {
    _coinImageViewModel = StateObject(wrappedValue: .init(coin: coin))
  }

  // MARK: - View
  var body: some View {
    ZStack {
      if let image = coinImageViewModel.image {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .clipShape(Circle())
      } else if coinImageViewModel.isLoading {
        ProgressView()
      } else {
        Image(systemName: IconNaming.shared.questionMark)
          .foregroundColor(Color.theme.secondaryText)
      }
    }
  }
}

// MARK: - Preview
struct CoinImageView_Previews: PreviewProvider {
  static var previews: some View {
    CoinImageView(coin: developer.coin)
      .padding()
      .previewLayout(.sizeThatFits)
      .preferredColorScheme(.dark)
  }
}

import SwiftUI

struct CoinLogoView: View {
  // MARK: - Properties
  let coin: Coin

  // MARK: - View
  var body: some View {
    VStack {
      CoinImageView(coin: coin)
        .frame(width: 50, height: 50)
      Text(coin.name.orEmpty)
        .foregroundColor(Color.theme.text)
        .font(.body)
        .bold()
        .multilineTextAlignment(.center)
      Text(coin.symbol.orEmpty.uppercased())
        .bold()
        .foregroundColor(Color.theme.secondaryText)
        .font(.caption)
    }
    .lineLimit(1)
  }
}

// MARK: - Preview
struct CoinLogoView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CoinLogoView(coin: developer.coin)
      CoinLogoView(coin: developer.coin)
        .preferredColorScheme(.dark)
    }
    .previewLayout(.sizeThatFits)
  }
}

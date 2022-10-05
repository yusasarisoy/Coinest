//
//  CoinLogoView.swift
//  Coinest
//
//  Created by Yuşa on 5.10.2022.
//

import SwiftUI

struct CoinLogoView: View {
  // MARK: - Properties
  let coin: Coin

  // MARK: - View
  var body: some View {
    VStack {
      CoinImageView(coin: coin)
        .frame(width: 50, height: 50)
      Text(coin.symbol.orEmpty.uppercased())
        .font(.headline)
        .foregroundColor(Color.theme.accent)
        .lineLimit(1)
        .minimumScaleFactor(0.5)
      Text(coin.name.orEmpty)
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .lineLimit(2)
        .minimumScaleFactor(0.5)
        .multilineTextAlignment(.center)
    }
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

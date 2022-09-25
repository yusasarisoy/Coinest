//
//  CoinRowView.swift
//  Coinest
//
//  Created by Yuşa on 24.09.2022.
//

import SwiftUI

struct CoinRowView: View {
  // MARK: - Properties
  let coin: Coin
  let showHoldings: Bool

  // MARK: - View
  var body: some View {
    HStack(spacing: .zero) {
      leftColumn
      Spacer()
      if showHoldings {
        centerColumn
      }
      rightColumn
    }
    .font(.subheadline)
  }
}

// MARK: - Column Views
extension CoinRowView {
  private var leftColumn: some View {
    HStack(spacing: .zero) {
      Text(coin.rank.toString)
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
      Image(ImageNaming.shared.bitcoin)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .clipShape(Circle())
        .frame(width: 30, height: 30)
      Text(coin.symbol.orEmpty.uppercased())
        .font(.headline)
        .padding(.leading, 6)
        .foregroundColor(Color.theme.accent)
    }
  }

  private var centerColumn: some View {
    VStack(alignment: .trailing) {
      Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
        .bold()
      Text(coin.currentHoldings.orZero.asNumberString())
    }
    .foregroundColor(Color.theme.accent)
  }

  private var rightColumn: some View {
    VStack(alignment: .trailing) {
      Text((coin.currentPrice?.asCurrencyWith6Decimals()).orEmptyPrice)
        .bold()
        .foregroundColor(Color.theme.accent)
      Text(coin.priceChangePercentage24H.orZero.asPercentString())
        .foregroundColor(coin.priceChangePercentage24H.orZero >= 0 ? Color.theme.green : Color.theme.red)
    }
    .frame(width: CGFloat.oneThirdOfWidth, alignment: .trailing)
  }
}

// MARK: - Preview
struct CoinRowView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CoinRowView(coin: developer.coin, showHoldings: true)
      CoinRowView(coin: developer.coin, showHoldings: true)
        .preferredColorScheme(.dark)
    }
    .previewLayout(.sizeThatFits)
  }
}

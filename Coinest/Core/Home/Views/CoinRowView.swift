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
private extension CoinRowView {
  var leftColumn: some View {
    HStack(spacing: .zero) {
      Text(coin.rank.toString)
        .font(.caption)
        .foregroundColor(Color.theme.text)
        .padding(.horizontal)
      CoinImageView(coin: coin)
        .frame(width: 30, height: 30)
      Text(coin.symbol.orEmpty.uppercased())
        .font(.headline)
        .padding(.leading, 6)
        .foregroundColor(Color.theme.text)
    }
  }

  var centerColumn: some View {
    VStack(alignment: .trailing) {
      Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
        .bold()
      Text("\(coin.currentHoldings.orZero.asNumberString()) \(coin.symbol.orEmpty.uppercased())")
    }
    .foregroundColor(Color.theme.text)
  }

  var rightColumn: some View {
    VStack(alignment: .trailing) {
      Text((coin.currentPrice?.asCurrencyWith4Decimals()).orEmptyPrice)
        .bold()
        .foregroundColor(Color.theme.text)
      Text(coin.priceChangePercentage24H.orZero.asPercentString())
        .foregroundColor(coin.priceChangePercentage24H.orZero >= 0 ? Color.theme.green : Color.theme.red)
    }
    .frame(width: CGFloat.oneThirdOfWidth, alignment: .trailing)
  }
}

// MARK: - Preview
struct CoinRowView_Previews: PreviewProvider {
  static var previews: some View {
    CoinRowView(coin: developer.coin, showHoldings: true)
      .previewLayout(.sizeThatFits)
      .preferredColorScheme(.dark)
  }
}

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
        .frame(width: 35)
        .scaledToFill()
        .minimumScaleFactor(0.01)
        .lineLimit(1)
        .foregroundColor(Color.theme.text)
      HStack {
        CoinImageView(coin: coin)
          .frame(width: 30, height: 30)
        Text(coin.symbol.orEmpty.uppercased())
          .font(.headline)
          .foregroundColor(Color.theme.text)
      }
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
      Text((coin.currentPrice?.asCurrencyWith6Decimals()).orEmptyPrice)
        .bold()
        .foregroundColor(Color.theme.text)
      HStack(spacing: 2) {
        Image(systemName: IconNaming.shared.triangle)
          .font(.caption2)
          .rotationEffect(.init(degrees: Double.updateTriangleRotation(coin.priceChangePercentage24H.orZero)))
        Text(coin.priceChangePercentage24H.orZero.asPercentString())
      }
      .foregroundColor(Color.optColorBasedOnChange(coin.priceChangePercentage24H.orZero))
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

//
//  StatisticView.swift
//  Coinest
//
//  Created by Yuşa on 2.10.2022.
//

import SwiftUI

struct StatisticView: View {
  // MARK: - Properties
  let statistic: Statistic

  // MARK: - View
  var body: some View {
    VStack(alignment: .center, spacing: 5) {
      Text(LocalizedStringKey(statistic.title))
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
      Text(statistic.value)
        .font(.headline)
        .foregroundColor(Color.theme.text)
      HStack(spacing: 2) {
        Image(systemName: IconNaming.shared.triangle)
          .font(.caption2)
          .rotationEffect(.init(degrees: Double.updateTriangleRotation(statistic.change.orZero)))
        Text(statistic.change.orZero.asPercentString())
          .font(.caption)
          .bold()
      }
      .foregroundColor(Color.optColorBasedOnChange(statistic.change.orZero))
      .opacity(statistic.change.isNil ? 0 : 1)
    }
  }
}

// MARK: - Preview
struct StatisticView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      StatisticView(statistic: developer.statisticWithPercentage)
      StatisticView(statistic: developer.statisticWithoutPercentage)
    }
    .previewLayout(.sizeThatFits)
  }
}

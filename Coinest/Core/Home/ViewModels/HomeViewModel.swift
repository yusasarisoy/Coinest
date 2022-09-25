//
//  HomeViewModel.swift
//  Coinest
//
//  Created by Yuşa on 25.09.2022.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
  // MARK: - Properties
  @Published var allCoins: [Coin] = []
  @Published var portfolioCoins: [Coin] = []

  // MARK: - Initialization
  init() {
    showCryptocurrenciesAndPortfolio()
  }
}

// MARK: - Private Helper Methods
private extension HomeViewModel {
  func showCryptocurrenciesAndPortfolio() {
    Task {
      try await Task.sleep(withSeconds: 2)
      allCoins.append(DeveloperPreview.instance.coin)
      portfolioCoins.append(DeveloperPreview.instance.coin)
    }
  }
}

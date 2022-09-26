//
//  HomeViewModel.swift
//  Coinest
//
//  Created by Yuşa on 25.09.2022.
//

import Combine
import SwiftUI

final class HomeViewModel: ObservableObject {
  // MARK: - Properties
  @Published var coins: [Coin] = []
  @Published var portfolioCoins: [Coin] = []

  private let dataService = CoinDataService()
  private var cancellables = Set<AnyCancellable>()

  // MARK: - Initialization
  init() {
    fetchCoins()
  }
}

// MARK: - Private Helper Methods
private extension HomeViewModel {
  func fetchCoins() {
    dataService.$coins
      .sink { [weak self] coins in
        guard let self = self else { return }
        self.coins = coins
      }
      .store(in: &cancellables)
  }
}

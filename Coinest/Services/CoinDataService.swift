//
//  CoinDataService.swift
//  Coinest
//
//  Created by Yuşa on 26.09.2022.
//

import Combine
import Foundation

final class CoinDataService {
  // MARK: - Properties
  @Published var coins: [Coin] = []
  var coinSubscription: AnyCancellable?

  // MARK: - Initialization
  init() {
    fetchCoins()
  }
}

// MARK: - Private Helper Methods
private extension CoinDataService {
  func fetchCoins() {
    guard let url = URL(string: APIConstants.url) else { return }

    coinSubscription = NetworkManager.download(url: url)
      .decode(type: [Coin].self, decoder: JSONDecoder())
      .sink(receiveCompletion: NetworkManager.handleCompletion,
            receiveValue: { [weak self] coins in
        guard let self = self else { return }
        self.coins = coins
        self.coinSubscription?.cancel()
      })
  }
}
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

  private var coinSubscription: AnyCancellable?

  // MARK: - Initialization
  init() {
    fetchCoins()
  }
}

// MARK: - Internal Helper Methods
extension CoinDataService {
  func fetchCoins(withPage page: Int = 1) {
    guard let url = URL(string: APIConstant.cryptocurrencyListURL(withPage: page)) else { return }

    coinSubscription = NetworkManager.download(url: url)
      .decode(type: [Coin].self, decoder: NetworkManager.jsonDecoder)
      .sink(receiveCompletion: NetworkManager.handleCompletion,
            receiveValue: { [weak self] coins in
        guard let self = self else { return }
        self.coins += coins
        self.coinSubscription?.cancel()
      })
  }
}

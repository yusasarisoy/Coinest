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

    coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
      .subscribe(on: DispatchQueue.global(qos: .background))
      .tryMap { output -> Data in
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode == 200 else {
          throw URLError(.badServerResponse)
        }

        return output.data
      }
      .receive(on: DispatchQueue.main)
      .decode(type: [Coin].self, decoder: JSONDecoder())
      .sink(receiveCompletion: { _ in },
            receiveValue: { [weak self] coins in
        guard let self = self else { return }
        self.coins = coins
        self.coinSubscription?.cancel()
      })
  }
}

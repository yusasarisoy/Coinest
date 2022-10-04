//
//  MarketDataService.swift
//  Coinest
//
//  Created by Yuşa on 3.10.2022.
//

import Combine
import Foundation

final class MarketDataService {
  // MARK: - Properties
  @Published var marketData: MarketData?

  private var marketDataSubscription: AnyCancellable?

  // MARK: - Initialization
  init() {
    fetchMarketData()
  }
}

// MARK: - Private Helper Methods
private extension MarketDataService {
  func fetchMarketData() {
    guard let url = URL(string: APIConstants.marketDataURL) else { return }

    marketDataSubscription = NetworkManager.download(url: url)
      .decode(type: GlobalData.self, decoder: NetworkManager.jsonDecoder)
      .sink(receiveCompletion: NetworkManager.handleCompletion,
            receiveValue: { [weak self] globalData in
        guard let self = self else { return }
        self.marketData = globalData.data
        self.marketDataSubscription?.cancel()
      })
  }
}

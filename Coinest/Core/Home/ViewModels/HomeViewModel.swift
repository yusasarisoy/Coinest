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
  @Published var statistics: [Statistic] = []

  @Published var coins: [Coin] = []
  @Published var portfolioCoins: [Coin] = []

  @Published var searchText = String.empty

  private let coinDataService = CoinDataService()
  private let marketDataService = MarketDataService()
  private var cancellables = Set<AnyCancellable>()

  // MARK: - Initialization
  init() {
    fetchCoinsWithFiltering()
  }
}

// MARK: - Private Helper Methods
private extension HomeViewModel {
  func fetchCoinsWithFiltering() {
    $searchText
      .combineLatest(coinDataService.$coins)
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .map(filterCoins)
      .sink { [weak self] filteredCoins in
        guard let self = self else { return }
        self.coins = filteredCoins
      }
      .store(in: &cancellables)

    marketDataService.$marketData
      .map(mapGlobalData)
      .sink { [weak self] statistics in
        guard let self = self else { return }

        self.statistics = statistics
      }
      .store(in: &cancellables)
  }

  func filterCoins(withText text: String, coins: [Coin]) -> [Coin] {
    guard text.isNotEmpty else { return coins }
    let coinName = text.lowercased()
    return coins.filter {
      $0.name.orEmpty.lowercased().contains(coinName) ||
      $0.symbol.orEmpty.lowercased().contains(coinName) ||
      $0.id.orEmpty.lowercased().contains(coinName)
    }
  }

  func mapGlobalData(marketData: MarketData?) -> [Statistic] {
    guard let marketData = marketData else { return [] }

    let marketCap = Statistic(
      title: "Market Cap",
      value: marketData.marketCap,
      change: marketData.marketCapChangePercentage24HUsd
    )
    let totalVolume = Statistic(
      title: "Total Volume",
      value: marketData.volume
    )
    let bitcoinDominance = Statistic(
      title: "BTC Dominance",
      value: marketData.bitcoinDominance
    )
    let portfolio = Statistic(
      title: "Portfolio Value",
      value: .orEmptyPrice,
      change: .zero
    )

    return [
      marketCap,
      totalVolume,
      bitcoinDominance,
      portfolio
    ]
  }
}

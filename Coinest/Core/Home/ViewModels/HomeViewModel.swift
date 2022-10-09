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

  private var cancellables = Set<AnyCancellable>()
  private lazy var coreDataStack = CoreDataStack()

  // MARK: - Data Services
  private let coinDataService = CoinDataService()
  private let marketDataService = MarketDataService()
  private lazy var portfolioDataService = PortfolioDataService(
    managedObjectContext: coreDataStack.mainContext,
    coreDataStack: coreDataStack
  )

  // MARK: - Initialization
  init() {
    fetchCoinsWithFiltering()
  }
}

// MARK: - Public Helper Methods
extension HomeViewModel {
  func updatePortfolio(withCoin coin: Coin, withAmount amount: Double) {
    portfolioDataService.updatePortfolio(withCoin: coin, withAmount: amount)
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

    $coins
      .combineLatest(portfolioDataService.$portfolioEntities)
      .map(mapAllCoinsToPortfolioCoins)
      .sink { [weak self] coins in
        guard let self = self else { return }
        self.portfolioCoins = coins
      }
      .store(in: &cancellables)

    marketDataService.$marketData
      .combineLatest($portfolioCoins)
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

  func mapAllCoinsToPortfolioCoins(
    coins: [Coin],
    portfolioEntities: [PortfolioEntity]
  ) -> [Coin] {
    coins.compactMap { coin -> Coin? in
      guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id.orEmpty }) else {
        return nil
      }
      return coin.updateHoldings(withAmount: entity.amount)
    }
  }

  func mapGlobalData(
    marketData: MarketData?,
    portfolioCoins: [Coin]
  ) -> [Statistic] {
    guard let marketData = marketData else { return [] }

    let portfolioValue = portfolioCoins
      .map { $0.currentHoldingsValue }
      .reduce(0, +)
    let lastDayPortfolioValue: Double = portfolioCoins
      .map {
        let currentValue = $0.currentHoldingsValue
        let percentChange = $0.marketCapChangePercentage24H.toPercentage
        return currentValue / (1 + percentChange)
      }
      .reduce(0, +)
    let percentageChange = ((portfolioValue - lastDayPortfolioValue) / lastDayPortfolioValue).toPercentageChange
    
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
      value: portfolioValue.asCurrencyWith2Decimals(),
      change: percentageChange
    )

    return [
      marketCap,
      totalVolume,
      bitcoinDominance,
      portfolio
    ]
  }
}

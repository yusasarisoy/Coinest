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
  @Published var sortOption: SortOption = .rank

  private var cancellables = Set<AnyCancellable>()
  private let coinDataService = CoinDataService()
  private let marketDataService = MarketDataService()
  private lazy var coreDataStack = CoreDataStack()
  private lazy var portfolioDataService = PortfolioDataService(
    managedObjectContext: coreDataStack.mainContext,
    coreDataStack: coreDataStack
  )

  // MARK: - Initialization
  init() {
    fetchCoinsWithFiltering()
  }
}

// MARK: - Internal Helper Methods
extension HomeViewModel {
  func refreshData() {
    coinDataService.fetchCoins()
    marketDataService.fetchMarketData()
  }

  func updatePortfolio(
    withCoin coin: Coin,
    withAmount amount: Double
  ) {
    portfolioDataService.updatePortfolio(withCoin: coin, withAmount: amount)
  }
}

// MARK: - Private Helper Methods
private extension HomeViewModel {
  func fetchCoinsWithFiltering() {
    $searchText
      .combineLatest(
        coinDataService.$coins,
        $sortOption
      )
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .map(filterAndSortCoins)
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
        self.portfolioCoins = self.sortPortfolioCoinsBySortOption(coins: coins)
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

  func filterAndSortCoins(
    withText text: String,
    coins: [Coin],
    sortOption: SortOption
  ) -> [Coin] {
    var updatedCoins = filterCoins(
      withText: text,
      coins: coins
    )
    sortCoins(
      coins: &updatedCoins,
      sortOption: sortOption
    )
    return updatedCoins
  }

  func filterCoins(
    withText text: String,
    coins: [Coin]
  ) -> [Coin] {
    guard text.isNotEmpty else { return coins }
    let coinName = text.lowercased()
    return coins.filter {
      $0.name.orEmpty.lowercased().contains(coinName) ||
      $0.symbol.orEmpty.lowercased().contains(coinName) ||
      $0.id.orEmpty.lowercased().contains(coinName)
    }
  }

  func sortCoins(
    coins: inout [Coin],
    sortOption: SortOption
  ) {
    switch sortOption {
    case .rank,
        .holdings:
      coins.sort(by: { $0.rank < $1.rank })
    case .rankReversed,
        .holdingsReversed:
      coins.sort(by: { $0.rank > $1.rank })
    case .price:
      coins.sort(by: { $0.currentPrice.orZero > $1.currentPrice.orZero })
    case .priceReversed:
      coins.sort(by: { $0.currentPrice.orZero < $1.currentPrice.orZero })
    }
  }

  func sortPortfolioCoinsBySortOption(coins: [Coin]) -> [Coin] {
    switch sortOption {
    case .holdings:
      return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
    case .holdingsReversed:
      return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
    default:
      return coins
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

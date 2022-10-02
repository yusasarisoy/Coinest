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
  @Published var statistics: [Statistic] = [
    .init(title: "Title", value: "Value", change: 1),
    .init(title: "Title", value: "Value"),
    .init(title: "Title", value: "Value", change: -1),
  ]

  @Published var coins: [Coin] = []
  @Published var portfolioCoins: [Coin] = []

  @Published var searchText = String.empty

  private let dataService = CoinDataService()
  private var cancellables = Set<AnyCancellable>()

  // MARK: - Initialization
  init() {
    fetchCoinsWithFiltering()
  }
}

// MARK: - Private Helper Methods
private extension HomeViewModel {
  func fetchCoinsWithFiltering() {
    dataService.$coins
      .sink { [weak self] coins in
        guard let self = self else { return }
        self.coins = coins
      }
      .store(in: &cancellables)

    $searchText
      .combineLatest(dataService.$coins)
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .map(filterCoins)
      .sink { [weak self] filteredCoins in
        guard let self = self else { return }
        self.coins = filteredCoins
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
}

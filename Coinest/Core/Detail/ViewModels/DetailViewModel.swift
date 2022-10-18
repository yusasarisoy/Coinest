//
//  DetailViewModel.swift
//  Coinest
//
//  Created by Yuşa on 18.10.2022.
//

import Combine

final class DetailViewModel: ObservableObject {
  // MARK: - Properties
  private let coinDetailService: CoinDetailDataService
  private var cancellables = Set<AnyCancellable>()

  // MARK: - Initialization
  init(coin: Coin) {
    coinDetailService = CoinDetailDataService(coin: coin)
    addSubscribers()
  }
}

// MARK: - Private Helper Methods
private extension DetailViewModel {
  func addSubscribers() {
    coinDetailService.$coinDetails
      .sink { _ in }
      .store(in: &cancellables)
  }
}

//
//  CoinImageViewModel.swift
//  Coinest
//
//  Created by Yuşa on 28.09.2022.
//

import Combine
import UIKit

final class CoinImageViewModel: ObservableObject {
  // MARK: - Properties
  @Published var image: UIImage?
  @Published var isLoading = false

  private let coin: Coin
  private let dataService: CoinImageService
  private var cancellables = Set<AnyCancellable>()

  // MARK: - Initialization
  init(coin: Coin) {
    self.coin = coin
    dataService = CoinImageService(coin: coin)
    addSubscribers()
  }
}

// MARK: - Private Helper Methods
private extension CoinImageViewModel {
  func addSubscribers() {
    isLoading = true

    dataService.$image
      .sink { [weak self] _ in
        guard let self else { return }
        self.isLoading = false
      } receiveValue: { [weak self] image in
        guard let self else { return }
        self.image = image
      }
      .store(in: &cancellables)
  }
}

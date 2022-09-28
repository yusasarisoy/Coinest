//
//  CoinImageService.swift
//  Coinest
//
//  Created by Yuşa on 28.09.2022.
//

import Combine
import SwiftUI

final class CoinImageService {
  // MARK: - Properties
  @Published var image: UIImage?

  private var imageSubscription: AnyCancellable?
  private let coin: Coin

  // MARK: - Initialization
  init(coin: Coin) {
    self.coin = coin

    fetchCoinImage()
  }
}

// MARK: - Private Helper Methods
private extension CoinImageService {
  func fetchCoinImage() {
    guard let url = URL(string: coin.image.orEmpty) else { return }

    imageSubscription = NetworkManager.download(url: url)
      .tryMap { data -> UIImage? in
        return .init(data: data)
      }
      .sink(receiveCompletion: NetworkManager.handleCompletion,
            receiveValue: { [weak self] image in
        guard let self = self else { return }
        self.image = image
        self.imageSubscription?.cancel()
      })
  }
}

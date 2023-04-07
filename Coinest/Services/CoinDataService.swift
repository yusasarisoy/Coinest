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
        guard let self else { return }
        self.coins += coins
        coinSubscription?.cancel()
      })
  }
}

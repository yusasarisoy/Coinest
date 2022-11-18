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

// MARK: - Internal Helper Methods
extension MarketDataService {
  func fetchMarketData() {
    guard let url = URL(string: APIConstant.marketDataURL) else { return }

    marketDataSubscription = NetworkManager.download(url: url)
      .decode(type: GlobalData.self, decoder: NetworkManager.jsonDecoder)
      .sink(receiveCompletion: NetworkManager.handleCompletion,
            receiveValue: { [weak self] globalData in
        guard let self else { return }
        self.marketData = globalData.data
        self.marketDataSubscription?.cancel()
      })
  }
}

import Combine
import Foundation

final class CoinDetailDataService {
  // MARK: - Properties
  @Published var coinDetails: CoinDetail?

  private var coinDetailSubscription: AnyCancellable?

  // MARK: - Initialization
  init(coin: Coin) {
    fetchCoinDetails(withCoinID: coin.id)
  }
}

// MARK: - Internal Helper Methods
extension CoinDetailDataService {
  func fetchCoinDetails(withCoinID coinID: String?) {
    guard
      let coinID = coinID,
      let url = URL(string: APIConstant.coinDetailsURL(for: coinID))
    else { return }

    coinDetailSubscription = NetworkManager.download(url: url)
      .decode(type: CoinDetail.self, decoder: NetworkManager.jsonDecoder)
      .sink(receiveCompletion: NetworkManager.handleCompletion,
            receiveValue: { [weak self] coinDetails in
        guard let self else { return }
        self.coinDetails = coinDetails
        coinDetailSubscription?.cancel()
      })
  }
}

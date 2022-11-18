import Combine

final class DetailViewModel: ObservableObject {
  // MARK: - Properties
  @Published var coin: Coin
  @Published var overviewStatistics: [Statistic] = []
  @Published var additionalDetailsStatistics: [Statistic] = []

  private let coinDetailService: CoinDetailDataService
  private var cancellables = Set<AnyCancellable>()

  // MARK: - Initialization
  init(coin: Coin) {
    self.coin = coin
    coinDetailService = CoinDetailDataService(coin: coin)
    addSubscribers()
  }
}

// MARK: - Private Helper Methods
private extension DetailViewModel {
  func addSubscribers() {
    coinDetailService.$coinDetails
      .combineLatest($coin)
      .map(mapCoinDetails)
      .sink { [weak self] statistics in
        guard let self else { return }
        self.overviewStatistics = statistics.overview
        self.additionalDetailsStatistics = statistics.additionalDetails
      }
      .store(in: &cancellables)
  }

  func mapCoinDetails(
    _ coinDetail: CoinDetail?,
    coin: Coin
  ) -> (
    overview: [Statistic],
    additionalDetails: [Statistic]
  ) {
    (
      populateOverview(by: coin),
      populateAdditionalDetails(
        coinDetail,
        by: coin
      )
    )
  }

  func populateOverview(by coin: Coin) -> [Statistic] {
    let price = (coin.currentPrice?.asCurrencyWith6Decimals()).orEmpty
    let priceChange = coin.priceChangePercentage24H
    let priceStatistics = Statistic(
      title: "price",
      value: price,
      change: priceChange
    )

    let marketCap = (coin.marketCap?.formattedWithAbbreviations().prependDollarSign).orEmpty
    let marketCapChange = coin.marketCapChangePercentage24H
    let marketCapStatistics = Statistic(
      title: "marketCap",
      value: marketCap,
      change: marketCapChange
    )

    let rank = coin.rank.toString
    let rankStatistics = Statistic(
      title: "rank",
      value: rank
    )

    let volume = (coin.totalVolume?.formattedWithAbbreviations().prependDollarSign).orEmpty
    let volumeStatistics = Statistic(
      title: "totalVolume",
      value: volume
    )

    return [
      priceStatistics,
      marketCapStatistics,
      rankStatistics,
      volumeStatistics
    ]
  }

  func populateAdditionalDetails(
    _ coinDetail: CoinDetail?,
    by coin: Coin
  ) -> [Statistic] {
    let high = (coin.high24H?.asCurrencyWith6Decimals()).orEmpty
    let highStatistics = Statistic(
      title: "24hHigh",
      value: high
    )

    let low = (coin.low24H?.asCurrencyWith6Decimals()).orEmpty
    let lowStatistics = Statistic(
      title: "24hLow",
      value: low
    )

    let priceChange = (coin.priceChange24H?.asCurrencyWith6Decimals()).orEmpty
    let pricePercentageChange = coin.priceChangePercentage24H
    let priceStatistics = Statistic(
      title: "24hPriceChange",
      value: priceChange,
      change: pricePercentageChange
    )

    let marketCapChange = (coin.marketCapChange24H?.formattedWithAbbreviations().prependDollarSign).orEmpty
    let marketCapPercentageChange = coin.marketCapChangePercentage24H
    let marketCapChangeStatistics = Statistic(
      title: "24hMarketCapChange",
      value: marketCapChange,
      change: marketCapPercentageChange
    )

    let blockTime = (coinDetail?.blockTimeInMinutes?.toString).orEmpty
    let blockTimeStatistics = Statistic(
      title: "blockTime",
      value: blockTime
    )

    let hashing = (coinDetail?.hashingAlgorithm).orEmpty
    let hashingStatistics = Statistic(
      title: "hashingAlgorithm",
      value: hashing
    )

    return [
      highStatistics,
      lowStatistics,
      priceStatistics,
      marketCapChangeStatistics,
      blockTimeStatistics,
      hashingStatistics
    ]
  }
}

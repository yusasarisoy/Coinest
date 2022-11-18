struct Coin: Identifiable, Decodable {
  let id: String?
  let symbol: String?
  let name: String?
  let image: String?
  let currentPrice: Double?
  let marketCap: Double?
  let marketCapRank: Double?
  let fullyDilutedValuation: Double?
  let totalVolume: Double?
  let high24H: Double?
  let low24H: Double?
  let priceChange24H: Double?
  let priceChangePercentage24H: Double?
  let marketCapChange24H: Double?
  let marketCapChangePercentage24H: Double?
  let circulatingSupply: Double?
  let totalSupply: Double?
  let maxSupply: Double?
  let ath: Double?
  let athChangePercentage: Double?
  let athDate: String?
  let atl: Double?
  let atlChangePercentage: Double?
  let atlDate: String?
  let lastUpdated: String?
  let sparklineIn7D: SparklineIn7D?
  let priceChangePercentage24HInCurrency: Double?
  let currentHoldings: Double?

  // MARK: - SparklineIn7D
  struct SparklineIn7D: Decodable {
    let price: [Double]?
  }

  // MARK: - Helpers
  func updateHoldings(withAmount amount: Double) -> Self {
    .init(
      id: id,
      symbol: symbol,
      name: name,
      image: image,
      currentPrice: currentPrice,
      marketCap: marketCap,
      marketCapRank: marketCapRank,
      fullyDilutedValuation: fullyDilutedValuation,
      totalVolume: totalVolume,
      high24H: high24H,
      low24H: low24H,
      priceChange24H: priceChange24H,
      priceChangePercentage24H: priceChangePercentage24H,
      marketCapChange24H: marketCapChange24H,
      marketCapChangePercentage24H: marketCapChangePercentage24H,
      circulatingSupply: circulatingSupply,
      totalSupply: totalSupply,
      maxSupply: maxSupply,
      ath: ath,
      athChangePercentage: athChangePercentage,
      athDate: athDate,
      atl: atl,
      atlChangePercentage: atlChangePercentage,
      atlDate: atlDate,
      lastUpdated: lastUpdated,
      sparklineIn7D: sparklineIn7D,
      priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency,
      currentHoldings: amount
    )
  }

  var currentHoldingsValue: Double {
    currentHoldings.orZero * currentPrice.orZero
  }

  var rank: Int {
    marketCapRank.toInt
  }
}

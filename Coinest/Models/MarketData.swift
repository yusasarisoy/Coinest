//
//  MarketData.swift
//  Coinest
//
//  Created by Yuşa on 3.10.2022.
//

struct GlobalData: Decodable {
  let data: MarketData?
}

struct MarketData: Decodable {
  let totalMarketCap: [String: Double]?
  let totalVolume: [String: Double]?
  let marketCapPercentage: [String: Double]?
  let marketCapChangePercentage24HUsd: Double?

  var marketCap: String {
    if let marketCapAsUSD = totalMarketCap?.first(where: { $0.key == "usd" }) {
      return marketCapAsUSD.value.formattedWithAbbreviations().prependDollarSign
    }

    return .empty
  }

  var volume: String {
    if let volumeAsUSD = totalVolume?.first(where: { $0.key == "usd" }) {
      return volumeAsUSD.value.formattedWithAbbreviations().prependDollarSign
    }

    return .empty
  }

  var bitcoinDominance: String {
    if let btcDominance = marketCapPercentage?.first(where: { $0.key == "btc" }) {
      return btcDominance.value.asPercentString()
    }

    return .empty
  }
}

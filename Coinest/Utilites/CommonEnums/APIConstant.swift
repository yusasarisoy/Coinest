//
//  APIConstant.swift
//  Coinest
//
//  Created by Yuşa on 26.09.2022.
//

enum APIConstant {
  static let top100URL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h"
  static let marketDataURL = "https://api.coingecko.com/api/v3/global"
}

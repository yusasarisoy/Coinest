enum APIConstant {
  static func cryptocurrencyListURL(withPage page: Int) -> String { "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=\(page)&sparkline=true&price_change_percentage=24h"
  }
  
  static let marketDataURL = "https://api.coingecko.com/api/v3/global"

  static func coinDetailsURL(for coinID: String) -> String { "https://api.coingecko.com/api/v3/coins/\(coinID)?tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
  }
}

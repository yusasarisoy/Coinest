struct CoinDetail: Decodable {
  let id: String?
  let symbol: String?
  let name: String?
  let blockTimeInMinutes: Int?
  let hashingAlgorithm: String?
  let localization: Description?
  let description: Description?
  let links: Links?
}

struct Links: Decodable {
  let homepage: [String]?
  let subredditURL: String?
}

struct Description: Decodable {
  let en: String?
  let tr: String?
}

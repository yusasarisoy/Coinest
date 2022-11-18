@testable import Coinest
import XCTest

final class LocalizationTests: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func test_btc_dominance_text() {
    let btcDominanceEnglish = "btcDominance".localized("en")
    let btcDominanceTurkish = "btcDominance".localized("tr")
    XCTAssertEqual(btcDominanceEnglish, "BTC Dominance")
    XCTAssertEqual(btcDominanceTurkish, "BTC Hakimiyeti")
  }
}

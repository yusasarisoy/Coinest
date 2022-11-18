@testable import Coinest
import CoreData
import XCTest

final class CoinestTests: XCTestCase {
  // MARK: - Properties
  var portfolioDataService: PortfolioDataService!
  var coreDataStack: CoreDataStack!
  
  override func setUp() {
    super.setUp()
    coreDataStack = TestCoreDataStack()
    portfolioDataService = PortfolioDataService(
      managedObjectContext: coreDataStack.mainContext,
      coreDataStack: coreDataStack
    )
  }

  override func tearDown() {
    super.tearDown()
    portfolioDataService = nil
    coreDataStack = nil
  }

  func test_add_coin_to_portfolio() {
    let coinInstance = DeveloperPreview.instance.coin
    let portfolioEntity = portfolioDataService.addCoin(
      coinInstance,
      withAmount: 1.5
    )

    XCTAssertNotNil(portfolioEntity, "Portfolio entity should not be nil")
    XCTAssertEqual(portfolioEntity.amount, 1.5)
    XCTAssertTrue(portfolioEntity.coinID == "bitcoin")
    XCTAssertEqual(coinInstance.name, "Bitcoin")
  }

  func test_get_portfolio() {
    let coinInstance = DeveloperPreview.instance.coin
    let portfolioEntity = portfolioDataService.addCoin(
      coinInstance,
      withAmount: 1.5
    )

    let portfolio = portfolioDataService.fetchPortfolio()

    XCTAssertNotNil(portfolio)
    XCTAssertTrue(portfolioDataService.portfolioEntities.count == 1)
    XCTAssertTrue(portfolioEntity.coinID == portfolioDataService.portfolioEntities.first?.coinID)
  }
}

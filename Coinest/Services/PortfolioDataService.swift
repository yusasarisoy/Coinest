import CoreData

final class PortfolioDataService {
  // MARK: - Properties
  let managedObjectContext: NSManagedObjectContext
  let coreDataStack: CoreDataStack

  // MARK: - Initialization
  init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
    self.managedObjectContext = managedObjectContext
    self.coreDataStack = coreDataStack

    fetchPortfolio()
  }

  @Published var portfolioEntities: [PortfolioEntity] = []
}

// MARK: - Internal Helper Methods
extension PortfolioDataService {
  func updatePortfolio(withCoin coin: Coin, withAmount amount: Double) {
    guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id.orEmpty })
    else {
      addCoin(coin, withAmount: amount)
      return
    }

    if amount > .zero {
      updateCoin(entity: entity, withAmount: amount)
    } else {
      deleteCoin(entity: entity)
    }
  }

  @discardableResult
  func fetchPortfolio() -> [PortfolioEntity] {
    let request = NSFetchRequest<PortfolioEntity>(entityName: CoreDataConstant.entityName)
    do {
      portfolioEntities = try coreDataStack.storeContainer.viewContext.fetch(request)
    } catch {
      print("An error occurred while fetching the portfolio: \(error.localizedDescription)")
    }

    return portfolioEntities
  }

  @discardableResult
  func addCoin(_ coin: Coin, withAmount amount: Double) -> PortfolioEntity {
    let entity = PortfolioEntity(context: coreDataStack.storeContainer.viewContext)
    entity.coinID = coin.id.orEmpty
    entity.amount = amount
    applyCoinChanges()
    return entity
  }

  func updateCoin(entity: PortfolioEntity, withAmount amount: Double) {
    entity.amount = amount
    applyCoinChanges()
  }
}

// MARK: - Private Helper Methods
private extension PortfolioDataService {
  func deleteCoin(entity: PortfolioEntity) {
    coreDataStack.storeContainer.viewContext.delete(entity)
    applyCoinChanges()
  }

  func saveCoin() {
    coreDataStack.saveContext(managedObjectContext)
  }

  func applyCoinChanges() {
    saveCoin()
    fetchPortfolio()
  }
}

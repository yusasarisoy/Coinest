//
//  PortfolioDataService.swift
//  Coinest
//
//  Created by Yuşa on 6.10.2022.
//

import CoreData

final class PortfolioDataService {
  // MARK: - Enums
  private enum Constant {
    static let continerName = "PortfolioDataModel"
    static let entityName = "PortfolioEntity"
  }

  // MARK: - Properties
  private let container: NSPersistentContainer

  @Published var portfolioEntities: [PortfolioEntity] = []

  // MARK: - Initialization
  init() {
    container = .init(name: Constant.continerName)
    container.loadPersistentStores { _, error in
      if let error = error {
        print("An error occurred while loading the Core Data: \(error.localizedDescription)")
      }
    }
  }
}

// MARK: - Public Helper Methods
extension PortfolioDataService {
  func updatePortfolio(coin: Coin, withAmount amount: Double) {
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
}

// MARK: - Private Helper Methods
private extension PortfolioDataService {
  func fetchPortfolio() {
    let request = NSFetchRequest<PortfolioEntity>(entityName: Constant.entityName)
    do {
      portfolioEntities = try container.viewContext.fetch(request)
    } catch {
      print("An error occurred while fetching the portfolio: \(error.localizedDescription)")
    }
  }

  func addCoin(_ coin: Coin, withAmount amount: Double) {
    let entity = PortfolioEntity(context: container.viewContext)
    entity.coinID = coin.id.orEmpty
    entity.amount = amount
    applyCoinChanges()
  }

  func updateCoin(entity: PortfolioEntity, withAmount amount: Double) {
    entity.amount = amount
    applyCoinChanges()
  }

  func deleteCoin(entity: PortfolioEntity) {
    container.viewContext.delete(entity)
    applyCoinChanges()
  }

  func saveCoin() {
    do {
      try container.viewContext.save()
    } catch {
      print("An error occurred while saving a coin: \(error.localizedDescription)")
    }
  }

  func applyCoinChanges() {
    saveCoin()
    fetchPortfolio()
  }
}

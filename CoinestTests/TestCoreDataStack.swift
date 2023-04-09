@testable import Coinest
import CoreData

final class TestCoreDataStack: CoreDataStack {
  override init() {
    super.init()

    let persistentStoreDescription = NSPersistentStoreDescription()
    persistentStoreDescription.type = NSInMemoryStoreType

    let container = NSPersistentContainer(name: CoreDataConstant.continerName)
    container.persistentStoreDescriptions = [persistentStoreDescription]

    container.loadPersistentStores { _, error in
      if let error {
        fatalError("An error occurred while loading the Core Data in test: \(error.localizedDescription)")
      }
    }

    storeContainer = container
  }
}

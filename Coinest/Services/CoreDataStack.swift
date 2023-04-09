import CoreData

class CoreDataStack {
  // MARK: - Properties
  private static let model: NSManagedObjectModel = {
    let modelURL = Bundle.main.url(
      forResource: CoreDataConstant.continerName,
      withExtension: "momd"
    )!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()

  lazy var mainContext: NSManagedObjectContext = {
    storeContainer.viewContext
  }()

  lazy var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: CoreDataConstant.continerName)
    container.loadPersistentStores { _, error in
      if let error {
        fatalError("An error occurred while loading the Core Data: \(error.localizedDescription)")
      }
    }
    return container
  }()

  // MARK: - Initialization
  init() { }
}

// MARK: - Internal Helper Methods
extension CoreDataStack {
  func saveContext(_ context: NSManagedObjectContext) {
    guard context == mainContext else {
      saveDerivedContext(context)
      return
    }

    context.perform {
      do {
        try context.save()
      } catch let error as NSError {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }
}

// MARK: - Private Helper Methods
private extension CoreDataStack {
  func newDerivedContext() -> NSManagedObjectContext {
    storeContainer.newBackgroundContext()
  }

  func saveDerivedContext(_ context: NSManagedObjectContext) {
    context.perform { [weak self] in
      guard let self else { return }
      do {
        try context.save()
      } catch let error as NSError {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }

      saveContext(mainContext)
    }
  }
}

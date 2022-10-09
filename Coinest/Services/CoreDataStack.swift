//
//  CoreDataStack.swift
//  Coinest
//
//  Created by Yuşa on 9.10.2022.
//

import CoreData

class CoreDataStack {
  public static let model: NSManagedObjectModel = {
    // swiftlint:disable force_unwrapping
    let modelURL = Bundle.main.url(forResource: CoreDataConstant.continerName, withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()

  public init() {
  }

  public lazy var mainContext: NSManagedObjectContext = {
    return storeContainer.viewContext
  }()

  public lazy var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: CoreDataConstant.continerName)
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("An error occurred while loading the Core Data: \(error.localizedDescription)")
      }
    }
    return container
  }()

  public func newDerivedContext() -> NSManagedObjectContext {
    let context = storeContainer.newBackgroundContext()
    return context
  }

  public func saveContext() {
    saveContext(mainContext)
  }

  public func saveContext(_ context: NSManagedObjectContext) {
    if context != mainContext {
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

  public func saveDerivedContext(_ context: NSManagedObjectContext) {
    context.perform {
      do {
        try context.save()
      } catch let error as NSError {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }

      self.saveContext(self.mainContext)
    }
  }
}

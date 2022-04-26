//
//  CoreDataOrdersStore.swift
//  Orders
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import CoreData

public final class CoreDataOrdersStore: OrdersStore {
    
    private static let modelName = "OrdersStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataOrdersStore.self))

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    public init(storeURL: URL) throws {
        guard let model = CoreDataOrdersStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            container = try NSPersistentContainer.load(name: CoreDataOrdersStore.modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    public func insert(_ orders: [LocalOrderItem], insertionCompletion completion: @escaping InsertionCompletion) {
        perform { context in
            completion(Result {
                 let managedCache = try ManagedCache.newUniqueInstance(in: context)
                 managedCache.orders = ManagedOrder.orders(from: orders, in: context)
                  try context.save()
             })
         }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
          completion(Result {
              try ManagedCache.find(in: context).map {
                return $0.localFeed
                  }
              })
          }
    }

    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
}

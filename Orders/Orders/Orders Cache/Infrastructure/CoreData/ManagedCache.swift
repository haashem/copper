//
//  ManagedCache+CoreDataClass.swift
//  Orders
//
//  Created by Hashem Abounajmi on 23/04/2022.
//
//

import CoreData

@objc(ManagedCache)
class ManagedCache: NSManagedObject {
  @NSManaged var orders: NSOrderedSet
}

extension ManagedCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
       let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
       request.returnsObjectsAsFaults = false
       return try context.fetch(request).first
   }

    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
       try find(in: context).map(context.delete)
       return ManagedCache(context: context)
   }

    var localFeed: [LocalOrderItem] {
       return orders.compactMap { ($0 as? ManagedOrder)?.local }
   }
}

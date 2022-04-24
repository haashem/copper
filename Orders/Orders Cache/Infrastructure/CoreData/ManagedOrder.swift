//
//  ManagedOrder+CoreDataClass.swift
//  Orders
//
//  Created by Hashem Abounajmi on 23/04/2022.
//
//

import CoreData

@objc(ManagedOrder)
class ManagedOrder: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var currency: String
    @NSManaged var amount: NSDecimalNumber
    @NSManaged var orderType: String
    @NSManaged var orderStatus: String
    @NSManaged var createdAt: Date
    @NSManaged var cache: ManagedCache
}

extension ManagedOrder {
    static func orders(from localOrders: [LocalOrderItem], in context: NSManagedObjectContext) -> NSOrderedSet {
       return NSOrderedSet(array: localOrders.map { local in
           let managed = ManagedOrder(context: context)
           managed.id = local.id
           managed.currency = local.currency
           managed.amount = NSDecimalNumber(decimal: local.amount)
           managed.orderType = local.orderType
           managed.orderStatus = local.orderStatus
           managed.createdAt = local.createdAt
           return managed
       })
   }

    var local: LocalOrderItem {
        return LocalOrderItem(id: id, currency: currency, amount: amount.decimalValue, orderType: orderType, orderStatus: orderStatus, createdAt: createdAt)
   }
}

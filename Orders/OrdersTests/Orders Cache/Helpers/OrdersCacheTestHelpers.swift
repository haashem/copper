//
//  OrdersCacheTestHelpers.swift
//  OrdersTests
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import Foundation
import Orders

func uniqueOrderItem() -> OrderItem {
    return OrderItem(id: UUID().description, currency: "any", amount: 1, orderType: .withdraw, orderStatus: .canceled, createdAt: Date())
}

func uniqueOrders() -> (models: [OrderItem], local: [LocalOrderItem]) {
    let items = [uniqueOrderItem(), uniqueOrderItem()]
    let localItems = items.map{ LocalOrderItem(id: $0.id, currency: $0.currency, amount: $0.amount, orderType: $0.orderType.rawValue, orderStatus: $0.orderStatus.rawValue, createdAt: $0.createdAt) }
    
    return (items, localItems)
}

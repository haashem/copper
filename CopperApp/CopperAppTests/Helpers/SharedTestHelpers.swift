//
//  SharedTestHelpers.swift
//  CopperAppTests
//
//  Created by Hashem Abounajmi on 26/04/2022.
//

import Foundation
import Orders

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func uniqueOrders() -> [OrderItem] {
    return [OrderItem(id: UUID().uuidString, currency: "SOL", amount: 123, orderType: .sell, orderStatus: .canceled, createdAt: Date())]
}

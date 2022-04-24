//
//  LocalOrderItem.swift
//  Orders
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import Foundation

public struct LocalOrderItem: Equatable {
    public let id: String
    public let currency: String
    public let amount: Decimal
    public let orderType: String
    public let orderStatus: String
    public let createdAt: Date
    
    public init(id: String, currency: String, amount: Decimal, orderType: String, orderStatus: String, createdAt: Date) {
        self.id = id
        self.currency = currency
        self.amount = amount
        self.orderType = orderType
        self.orderStatus = orderStatus
        self.createdAt = createdAt
    }
}

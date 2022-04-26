//
//  OrderItem.swift
//  Orders
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import Foundation

public enum OrderType {
    case deposit, withdraw, buy, sell
}

public enum OrderStatus {
    case executed, canceled, approved, processing
}

public struct OrderItem: Equatable {
    public let id: String
    public let currency: String
    public let amount: Decimal
    public let orderType: OrderType
    public let orderStatus: OrderStatus
    public let createdAt: Date
    
    public init(id: String, currency: String, amount: Decimal, orderType: OrderType, orderStatus: OrderStatus, createdAt: Date) {
        self.id = id
        self.currency = currency
        self.amount = amount
        self.orderType = orderType
        self.orderStatus = orderStatus
        self.createdAt = createdAt
    }
}


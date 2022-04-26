//
//  OrderType+RawValue.swift
//  Orders
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import Foundation

extension OrderType  {
     init(rawValue: String) throws {
        switch rawValue {
        case "deposit":
            self = .deposit
        case "withdraw":
            self = .withdraw
        case "buy":
            self = .buy
        case "sell":
            self = .sell
        default: throw DecodingError.valueNotFound(OrderType.self, DecodingError.Context(codingPath: [], debugDescription: "value for orderType is not same as expected ones"))
        }
    }
}

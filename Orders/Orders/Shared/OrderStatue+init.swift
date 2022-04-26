//
//  OrderStatue+rawValue.swift
//  Orders
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import Foundation

extension OrderStatus  {
    init(rawValue: String) throws {
        switch rawValue {
        case "executed":
            self = .executed
        case "canceled":
            self = .canceled
        case "approved":
            self = .approved
        case "processing":
            self = .processing
        default: throw DecodingError.valueNotFound(OrderType.self, DecodingError.Context(codingPath: [], debugDescription: "value for orderStatus is not same as expected ones"))
        }
    }
}

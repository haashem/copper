//
//  OrderStatus+rawValue.swift
//  OrdersTests
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import Foundation
import Orders

extension OrderStatus  {
    var rawValue: String {
        switch self {
        case .executed:
            return "executed"
        case .approved:
            return "approved"
        case .canceled:
            return "canceled"
        case .processing:
            return "processing"
        }
    }
}

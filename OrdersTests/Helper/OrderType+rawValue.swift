//
//  OrderType+rawValue.swift
//  OrdersTests
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import Foundation
import Orders

extension OrderType  {
    var rawValue: String {
        switch self {
        case .sell:
            return "sell"
        case .buy:
            return "buy"
        case .withdraw:
            return "withdraw"
        case .deposit:
            return "deposit"
        }
    }
}

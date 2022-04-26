//
//  OrdersCache.swift
//  Orders
//
//  Created by Hashem Abounajmi on 25/04/2022.
//

import Foundation

public protocol OrdersCache {
    typealias Result = Swift.Result<Void, Error>
    func save(_ feed: [OrderItem], completion: @escaping (Result) -> Void)
}

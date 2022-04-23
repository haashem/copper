//
//  OrdersLoader.swift
//  Orders
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import Foundation

public protocol OrdersLoader {
    typealias Result = Swift.Result<[OrderItem], Error>
    func load(completion: @escaping (Result) -> Void)
}

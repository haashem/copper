//
//  OrdersLoaderStub.swift
//  CopperAppTests
//
//  Created by Hashem Abounajmi on 26/04/2022.
//

import Orders

class OrdersLoaderStub: OrdersLoader {
    private let result: OrdersLoader.Result
    init(result: OrdersLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (OrdersLoader.Result) -> Void) {
        completion(result)
    }
}

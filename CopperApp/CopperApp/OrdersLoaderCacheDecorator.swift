//
//  OrdersLoaderCacheDecorator.swift
//  CopperApp
//
//  Created by Hashem Abounajmi on 25/04/2022.
//

import Orders

public final class OrdersLoaderCacheDecorator: OrdersLoader {
    
    private let decoratee: OrdersLoader
    private let cache: OrdersCache
    
    public init(decoratee: OrdersLoader, cache: OrdersCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func load(completion: @escaping (OrdersLoader.Result) -> Void) {
        decoratee.load() { [weak self] result in
            completion(result.map{ orders in
                self?.cache.saveIgnoringResult(orders)
                return orders
            })
        }
    }
}

extension OrdersCache {
    func saveIgnoringResult(_ orders: [OrderItem]) {
        save(orders){ _ in }
    }
}


//
//  OrdersLoaderWithFallbackComposite.swift
//  CopperApp
//
//  Created by Hashem Abounajmi on 25/04/2022.
//

import Orders

public class OrdersLoaderWithFallbackComposite: OrdersLoader {
    
    private let primary: OrdersLoader
    private let fallback: OrdersLoader
    
    private var primaryTried = false
    public init(primary: OrdersLoader, fallback: OrdersLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    public func load(completion: @escaping (OrdersLoader.Result) -> Void) {
     
        if (primaryTried) {
            fallback.load(){ result in
                completion(result)
            }
        } else {
            primary.load { [weak self] result in
                self?.primaryTried = true
                completion(result)
            }
        }
    }
}

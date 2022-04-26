//
//  OrdersViewModel.swift
//  OrdersiOS
//
//  Created by Hashem Abounajmi on 24/04/2022.
//

import Orders

final public class OrdersViewModel {
    
    public typealias Observer<T> = (T) -> Void
    private let ordersLoader: OrdersLoader
    
    public init(ordersLoader: OrdersLoader) {
        self.ordersLoader = ordersLoader
    }
    
    public var onLoadingStateChange: Observer<Bool>?
    public var onOrdersLoad: Observer<[OrderItem]>?
    
    public func loadOrders() {
        onLoadingStateChange?(true)
        ordersLoader.load { [weak self] result in
            if let orders = try? result.get() {
                self?.onOrdersLoad?(orders)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}

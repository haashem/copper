//
//  OrdersViewModel.swift
//  OrdersiOS
//
//  Created by Hashem Abounajmi on 24/04/2022.
//

import Orders

final public class OrdersViewModel {
    
    typealias Observer<T> = (T) -> Void
    private let ordersLoader: OrdersLoader
    
    init(ordersLoader: OrdersLoader) {
        self.ordersLoader = ordersLoader
    }
    
    var onLoadingStateChange: Observer<Bool>?
    var onOrdersLoad: Observer<[OrderItem]>?
    
    func loadOrders() {
        onLoadingStateChange?(true)
        ordersLoader.load { [weak self] result in
            if let orders = try? result.get() {
                self?.onOrdersLoad?(orders)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}

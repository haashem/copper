//
//  FeedViewControllerTests+LoaderSpy.swift
//  CopperAppTests
//
//  Created by Hashem Abounajmi on 24/04/2022.
//
import Foundation
import Combine
import Orders

extension OrdersUIIntegrationTests {
    
    class LoaderSpy: OrdersLoader {
        private var ordersRequests = [(OrdersLoader.Result) -> Void]()
        
        var loadOrdersCallCount: Int {
            return ordersRequests.count
        }
        
        func load(completion: @escaping (OrdersLoader.Result) -> Void) {
            ordersRequests.append(completion)
        }
        
        func completeOrdersLoading(with orders: [OrderItem] = [], at index: Int = 0) {
            ordersRequests[index](.success(orders))
        }
        
        func completeOrdersLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            ordersRequests[index](.failure(error))
        }
    }
}

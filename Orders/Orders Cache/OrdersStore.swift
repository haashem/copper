//
//  OrdersStore.swift
//  Orders
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import Foundation

public typealias CachedOrders = [LocalOrderItem]

public protocol OrdersStore {
    
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Result<CachedOrders?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    
    /// Completion handler can be invoked in any threads.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func insert(_ orders: [LocalOrderItem], insertionCompletion: @escaping InsertionCompletion)
    
    /// Completion handler can be invoked in any threads.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func retrieve(completion: @escaping RetrievalCompletion)
}

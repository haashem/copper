//
//  LocalOrdersLoader.swift
//  Orders
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import Foundation

public final class LocalOrdersLoader {
    private let store: OrdersStore
    public init(store: OrdersStore) {
        self.store = store
    }
}

extension LocalOrdersLoader: OrdersCache {
    
    public typealias SaveResult = Result<Void, Error>
    
    public func save(_ orders: [OrderItem], completion: @escaping (SaveResult) -> Void) {
        self.cache(orders, with: completion)
    }
    
    private func cache(_ orders: [OrderItem], with completion: @escaping (SaveResult) -> Void) {
        store.insert(orders.toLocal(), insertionCompletion: { [weak self] error in
            guard let _ = self else { return }
            completion(error)
        })
    }
    
}

extension LocalOrdersLoader: OrdersLoader {
    
    public typealias LoadResult = Result<[OrderItem], Error>
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            case let .success(.some(cachedOrders)):
                completion(.success((try? cachedOrders.toModels()) ?? []))
                
            case .success:
                completion(.success([]))
            }
        }
    }
    
}

private extension Array where Element == OrderItem {
    func toLocal() -> [LocalOrderItem] {
        return map{ LocalOrderItem(id: $0.id, currency: $0.currency, amount: $0.amount, orderType: $0.orderType.rawValue, orderStatus: $0.orderStatus.rawValue, createdAt: $0.createdAt)}
    }
}

private extension Array where Element == LocalOrderItem {
    func toModels() throws -> [OrderItem] {
        return try map{ OrderItem(id: $0.id, currency: $0.currency, amount: $0.amount, orderType: try OrderType(rawValue: $0.orderType), orderStatus: try OrderStatus(rawValue: $0.orderStatus), createdAt: $0.createdAt) }
    }
}

private extension OrderType  {
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

private extension OrderStatus  {
    var rawValue: String {
        switch self {
        case .executed:
            return "executed"
        case .approved:
            return "approved"
        case .canceled:
            return "canceled"
        case .processing:
            return "processing"
        }
    }
}

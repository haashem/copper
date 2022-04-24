//
//  OrderItemMapper.swift
//  Orders
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import Foundation

final public class OrderItemsMapper {
    
    private struct Root: Decodable {
        private let orders: [RemoteOrderItem]
        
        private struct RemoteOrderItem: Decodable {
            public let orderId: String
            public let currency: String
            public let amount: String
            public let orderType: String
            public let orderStatus: String
            public let createdAt: String
        }
        
        
        func toModels() throws -> [OrderItem] {
            return try orders.map { item in
                let createdAtSeconds = TimeInterval(Double(item.createdAt)!/1000).rounded(.down);
                guard let amount = Decimal(string: item.amount) else { throw RemoteOrdersLoader.Error.invalidData }
                
                return OrderItem(id: item.orderId, currency: item.currency, amount: amount, orderType: try OrderType(rawValue: item.orderType), orderStatus: try OrderStatus(rawValue: item.orderStatus), createdAt: Date(timeIntervalSince1970: createdAtSeconds))
            }
        }
    }
    
    public static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [OrderItem] {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        
        guard response.isHTTPURLResponseOK, let root = try? decoder.decode(Root.self, from: data), let models = try? root.toModels() else {
            throw RemoteOrdersLoader.Error.invalidData
        }
        
        return models
    }
}

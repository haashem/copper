//
//  OrderItemViewModel.swift
//  OrdersiOS
//
//  Created by Hashem Abounajmi on 24/04/2022.
//

import Foundation
import Orders

final public class OrderItemViewModel {
    typealias Observer<T> = (T) -> Void
    private static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm a"
        return dateFormatter
    }()
    
    private static var amountFormatter = AmountFormatter()
    
    private let model: OrderItem
    
    public init(model: OrderItem) {
        self.model = model
    }
    
    var transaction: String {
        switch model.orderType {
            case .deposit:
                return "In \(model.currency)"
            case .withdraw:
                return "Out \(model.currency)"
            case .sell, .buy:
                return "\(model.currency) → BTC"
        }
    }

    var amount: String  {
        let amonut = "\(OrderItemViewModel.amountFormatter.string(from: model.amount as NSDecimalNumber)!) \(model.currency)"
        
        switch model.orderType {
        case .deposit, .buy:
            return "+\(amonut))"
        
        case .sell, .withdraw:
            return "-\(amonut)"
        }
    }

    var date: String {
        return OrderItemViewModel.dateFormatter.string(from: model.createdAt)
    }
    
    var status: String {
        return model.orderStatus.title
    }
}

private extension OrderStatus {
    var title: String {
        switch self {
        case .executed:
            return "Executed"
        case .canceled:
            return "Canceled"
        case .approved:
            return "Approved"
        case .processing:
            return "Processing"
        }
    }
}


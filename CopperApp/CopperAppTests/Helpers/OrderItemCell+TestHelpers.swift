//
//  OrderItemCell+TestHelpers.swift
//  CopperAppTests
//
//  Created by Hashem Abounajmi on 25/04/2022.
//

import UIKit
import OrdersiOS

extension OrderItemCell {
    
    var transactionLabelText: String? {
        return transactionLabel.text
    }
    
    var amountText: String? {
        return amountLable.text
    }
    
    var dateText: String? {
        return dateLabel.text
    }
    
    var statusText: String? {
        return statusLabel.text
    }
    
}

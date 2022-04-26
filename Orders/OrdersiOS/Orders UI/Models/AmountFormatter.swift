//
//  AmountFormatter.swift
//  OrdersiOS
//
//  Created by Hashem Abounajmi on 24/04/2022.
//

import Foundation

class AmountFormatter: NumberFormatter {
    override init() {
        super.init()
        maximumFractionDigits = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func string(from number: NSNumber) -> String? {
        if (number.intValue >= 1000) {
            return String(format: "%.1f", number.intValue / 1000) + "K"
        } else {
            return super.string(from: number)
        }
    }
}

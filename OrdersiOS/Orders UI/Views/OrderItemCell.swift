//
//  OrderItemCell.swift
//  OrdersiOS
//
//  Created by Hashem Abounajmi on 24/04/2022.
//

import UIKit

final public class OrderItemCell: UITableViewCell {
    @IBOutlet private(set) public var transactionLabel: UILabel!
    @IBOutlet private(set) public var amountLable: UILabel!
    @IBOutlet private(set) public var dateLabel: UILabel!
    @IBOutlet private(set) public var statusLabel: UILabel!
}

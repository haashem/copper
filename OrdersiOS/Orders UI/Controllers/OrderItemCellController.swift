//
//  OrderItemCellController.swift
//  OrdersiOS
//
//  Created by Hashem Abounajmi on 24/04/2022.
//

import UIKit

final public class OrderItemCellController {
    
    func view(in tableView: UITableView) -> UITableViewCell {
        let cell = binded(tableView.dequeueReusableCell())
        return cell
    }
    
    private var viewModel: OrderItemViewModel
    
    public init(viewModel: OrderItemViewModel) {
        self.viewModel = viewModel
    }
    
    private func binded(_ cell: OrderItemCell) -> OrderItemCell {
        cell.transactionLabel.text = viewModel.transaction
        cell.amountLable.text = viewModel.amount
        cell.dateLabel.text = viewModel.date
        cell.statusLabel.text = viewModel.status
    
        return cell
    }
}

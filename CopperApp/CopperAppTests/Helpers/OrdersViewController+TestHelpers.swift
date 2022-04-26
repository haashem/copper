//
//  OrdersViewController+TestHelpers.swift
//  CopperAppTests
//
//  Created by Hashem Abounajmi on 25/04/2022.
//
import UIKit
import OrdersiOS

extension OrdersViewController {
    func simulateUserInitiatedOrdersload() {
        downloadController?.download()
    }
    
    var isShowingLoadingIndicator: Bool {
        return downloadView?.activityIndicator.isAnimating == true
    }
    
    var isShowingDownloadView: Bool {
        return downloadView?.superview == view
    }
    
    func numberOfRenderedOrdersCells() -> Int {
        return tableView.numberOfRows(inSection: orderSection)
    }
    
    func orderCell(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedOrdersCells() > row else { return nil }
        let ds = tableView?.dataSource
        let index = IndexPath(row: row, section: orderSection)
        
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    private var orderSection: Int {
        return 0
    }
}


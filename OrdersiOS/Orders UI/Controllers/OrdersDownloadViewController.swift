//
//  OrdersDownloadController.swift
//  OrdersiOS
//
//  Created by Hashem Abounajmi on 24/04/2022.
//

import UIKit

final class OrdersDownloadViewController {
    var view: DownloadView? {
        didSet {
            guard let view = view else { return }
            bind(view)
        }
    }
    
    private var viewModel: OrdersViewModel
    
    init(viewModel: OrdersViewModel) {
        self.viewModel = viewModel
    }
    
    @objc func refresh() {
        viewModel.loadOrders()
    }
    
    private func bind(_ view: DownloadView)  {
        viewModel.onLoadingStateChange = { [weak view] isLoading in
            if isLoading {
                view?.beginRefreshing()
            } else {
                view?.endRefreshing()
            }
        }
        view.downloadButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
    }
}

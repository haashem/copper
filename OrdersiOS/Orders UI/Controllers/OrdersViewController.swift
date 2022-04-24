//
//  OrdersViewController.swift
//  OrdersiOS
//
//  Created by Hashem Abounajmi on 24/04/2022.
//

import UIKit

final public class OrdersViewController: UIViewController, UITableViewDataSource {
    
    private var refreshController: OrdersDownloadViewController?
    @IBOutlet private(set) var downloadView: DownloadView!
    @IBOutlet private(set) var tableView: UITableView!
    
    var tableModel = [OrderItemCellController]() {
        didSet {
            guard tableModel.isEmpty == false else {
                return
            }
            hideDownloadView()
            tableView.reloadData() }
    }
    
    convenience init(refreshController: OrdersDownloadViewController) {
        self.init()
        self.refreshController = refreshController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        showDownloadView()
        refreshController?.view = downloadView
        refreshController?.refresh()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> OrderItemCellController {
        return tableModel[indexPath.row]
    }
    
    private func showDownloadView() {
        view.addSubview(downloadView)
        downloadView.translatesAutoresizingMaskIntoConstraints = false
        downloadView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        downloadView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        downloadView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        downloadView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func hideDownloadView() {
        downloadView.removeFromSuperview()
    }
}


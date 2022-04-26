//
//  OrdersUIComposer.swift
//  CopperApp
//
//  Created by Hashem Abounajmi on 24/04/2022.
//

import UIKit
import Combine
import Orders
import OrdersiOS

final public class OrdersUIComposer {
    
    private init() {}
    
    public static func ordersComposedWith(ordersLoader: OrdersLoader) -> OrdersViewController {
        let ordersViewModel = OrdersViewModel(ordersLoader: MainQueueDispatchDecorater(decoratee: ordersLoader))
        let downloadController = OrdersDownloadViewController(viewModel: ordersViewModel)
        let ordersController = makeOrdersViewController()
        ordersController.downloadController = downloadController
        ordersViewModel.onOrdersLoad = adaptOrdersToCellControllers(forwardingTo: ordersController)
        
        return ordersController
    }
    
    private static func makeOrdersViewController() -> OrdersViewController {
        let bundle = Bundle(for: OrdersViewController.self)
        let storybaord = UIStoryboard(name: "Orders", bundle: bundle.self)
        let ordersViewController = storybaord.instantiateInitialViewController() as! OrdersViewController
        
        return ordersViewController;
    }
    
    private static func adaptOrdersToCellControllers(forwardingTo controller: OrdersViewController) -> ([OrderItem]) -> Void {
        
        return { [weak controller] orders in
            controller?.tableModel = orders.map { model in OrderItemCellController(viewModel: OrderItemViewModel(model: model))}
        }
    }
}

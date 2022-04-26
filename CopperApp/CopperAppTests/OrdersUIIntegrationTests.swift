//
//  OrdersUIIntegrationTests.swift
//  CopperAppTests
//
//  Created by Hashem Abounajmi on 24/04/2022.
//

import UIKit
import XCTest
import Orders
import OrdersiOS
import CopperApp

final class OrdersUIIntegrationTests: XCTestCase {
    
    func test_loadFeedActions_requestFeedFromLoader() {
       let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadOrdersCallCount, 0, "Expected no loading requests before veiw is loaded")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadOrdersCallCount, 1, "Expected a loading requets once view is loaded")
        
        sut.simulateUserInitiatedOrdersload()
        XCTAssertEqual(loader.loadOrdersCallCount, 2, "Expected another loading request once view is loaded")
    }
    
    func test_loadingIndicator_isVisibleWhileLoadingOrders() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once veiw is loaded")

        loader.completeOrdersLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfull")
        
        sut.simulateUserInitiatedOrdersload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")

        loader.completeOrdersLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completes with failure")
    }
    
    func test_downloadView_isVisibleWhileLoadingOrders() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingDownloadView, "Expected download view be visible once veiw is loaded")

        loader.completeOrdersLoading()
        XCTAssertTrue(sut.isShowingDownloadView, "Expected download view be visible once loaded items are empty")
        
        sut.simulateUserInitiatedOrdersload()
        XCTAssertTrue(sut.isShowingDownloadView, "Expected download view be visible once user initiates a reload")

        loader.completeOrdersLoadingWithError(at: 1)
        XCTAssertTrue(sut.isShowingDownloadView, "Expected download view be visible once user initiated loading is completes with failure")
        
        sut.simulateUserInitiatedOrdersload()
        let order0 = OrderItem(id: "0", currency: "XRP", amount: 1, orderType: .buy, orderStatus: .canceled, createdAt: Date())
        
        loader.completeOrdersLoading(with: [order0])
        XCTAssertFalse(sut.isShowingDownloadView, "Expected download view be hidden when items downloaded successfully")
    }
    
    func test_loadOrdersCompletion_rendersSuccessfullyLoadedOrders() {
        let order0 = OrderItem(id: "0", currency: "XRP", amount: 1, orderType: .buy, orderStatus: .canceled, createdAt: Date())
        let order1 = OrderItem(id: "1", currency: "DOGE", amount: 2000, orderType: .deposit, orderStatus: .executed, createdAt: Date())
        let order2 =  OrderItem(id: "2", currency: "MATIC", amount: 1.231232, orderType: .withdraw, orderStatus: .processing, createdAt: Date())
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeOrdersLoading(with: [order0, order1, order2])
        assertThat(sut, isRendering: [order0, order1, order2].map{OrderItemViewModel(model: $0)})
    }
    
    func test_loadOrdersCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeOrdersLoading(with: [OrderItem(id: "0", currency: "XRP", amount: 1, orderType: .buy, orderStatus: .canceled, createdAt: Date())])
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: OrdersViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = OrdersUIComposer.ordersComposedWith(ordersLoader: loader)
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
    
    private func makeOrder(id: String, currency: String, amount: Decimal, orderType: OrderType, orderStatus: OrderStatus, createdAt: Date) -> OrderItemViewModel {
        return OrderItemViewModel(model: OrderItem(id: id, currency: currency, amount: amount, orderType: orderType, orderStatus: orderStatus, createdAt: createdAt))
    }
}

//
//  OrdersAcceptanceTests.swift
//  CopperAppTests
//
//  Created by Hashem Abounajmi on 26/04/2022.
//

import XCTest
import UIKit
import Orders
import OrdersiOS
@testable import CopperApp

class OrdersAcceptanceTests: XCTestCase {
    
    func test_onLaunch_displaysDownloadViewWhenCacheIsEmpty() {
        
        let feed = launch(httpClient: .online(response), store: .empty)
        XCTAssertEqual(feed.numberOfRenderedOrdersCells(), 0)
        XCTAssertTrue(feed.isShowingDownloadView)
    }
    
    func test_onLaunch_displaysRemoteOrdersWhenUserRequestsDownloadOrders() {
        
        let feed = launch(httpClient: .online(response), store: .empty)
        XCTAssertEqual(feed.numberOfRenderedOrdersCells(), 0)
        XCTAssertTrue(feed.isShowingDownloadView)
        feed.simulateUserInitiatedOrdersload()
        XCTAssertEqual(feed.numberOfRenderedOrdersCells(), 2)
    }
    
    func test_onLaunch_displaysCachedOrdersWhenCacheIsNotEmpty() {
        
        let feed = launch(httpClient: .online(response), store: .withOrdersCache)
        XCTAssertEqual(feed.numberOfRenderedOrdersCells(), 1)
        XCTAssertFalse(feed.isShowingDownloadView)
    }
    
    // MARK: - Helpers
    
    private func launch(httpClient: HTTPClientStub = .offline, store: InMemoryOrdersStore = .empty) -> OrdersViewController {
        
        let sut = SceneDelegate(httpClient: httpClient, store: store)
        sut.window = UIWindow()
        sut.configureWindow()
        let nav = sut.window?.rootViewController as? UINavigationController
        let orderViewController = nav?.topViewController as! OrdersViewController
        orderViewController.loadViewIfNeeded()
        return orderViewController
    }
    
    private class HTTPClientStub: HTTPClient {

        
        private let stub: (URL) -> HTTPClient.Result
        init(stub: @escaping (URL) -> HTTPClient.Result) {
            self.stub = stub
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            completion(stub(url))
        }
        
        static var offline: HTTPClientStub {
            HTTPClientStub(stub: {_ in .failure(NSError(domain: "offline", code: 0))})
        }
        
        static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
            HTTPClientStub{ url in .success(stub(url)) }
        }
    }
    
    private class InMemoryOrdersStore: OrdersStore {
       
        var ordersCache: [LocalOrderItem]?
        init (ordersCache: [LocalOrderItem]? = nil) {
            self.ordersCache = ordersCache
        }
        
        func insert(_ orders: [LocalOrderItem], insertionCompletion: @escaping InsertionCompletion) {
            ordersCache = orders
            insertionCompletion(.success(()))
        }
        
        func retrieve(completion: @escaping RetrievalCompletion) {
            completion(.success(ordersCache))
        }
        
        static var empty: InMemoryOrdersStore {
            InMemoryOrdersStore()
        }
        
        static var withOrdersCache: InMemoryOrdersStore {
            InMemoryOrdersStore(ordersCache: [LocalOrderItem(id: "0", currency: "", amount: 23.23423, orderType: "sell", orderStatus: "executed", createdAt: Date())])
        }
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
         let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
         return (makeData(for: url), response)
     }
    
    private func makeData(for url: URL) -> Data {
        return makeOrdersData()
    }
    
    private func makeOrdersData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["orders": [
            ["orderId": UUID().uuidString, "currency": "BTC", "amount": "748.279727546401", "orderType": "deposit", "orderStatus": "approved", "createdAt": "1595770212105"],
            ["orderId": UUID().uuidString, "currency": "ADA", "amount": "46401.12312", "orderType": "deposit", "orderStatus": "canceled", "createdAt": "1595770217105"]
        ]])
    }
}

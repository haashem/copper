//
//  OrdersLoaderWithFallbackComposite.swift
//  CopperAppTests
//
//  Created by Hashem Abounajmi on 25/04/2022.
//

import XCTest
import Orders
import CopperApp

class OrdersLoaderWithFallbackCompositeTests: XCTestCase, OrdersLoaderTestCase {
    
    func test_load_deliversPrimaryFeedOnPrimaryLoaderSuccess() {
        
        let primaryOrders = uniqueOrders()
        let fallbackOrders = uniqueOrders()
        let sut = makeSUT(primaryResult: .success(primaryOrders), fallbackResult: .success(fallbackOrders))
       
        expect(sut, toCompleteWith: .success(primaryOrders))
    }
    
    func test_load_deliversFallbackAfterOnePrimaryAttempt() {
        let primaryOrders = [OrderItem]()
        let fallbackOrders = uniqueOrders()
        
        let sut = makeSUT(primaryResult: .success(primaryOrders), fallbackResult: .success(fallbackOrders))

        expect(sut, toCompleteWith: .success(primaryOrders))
        expect(sut, toCompleteWith: .success(fallbackOrders))
        expect(sut, toCompleteWith: .success(fallbackOrders))
    }

    func test_load_deliversErrorOnBothPrimaryAndFallbackLoaderFailure() {
        
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .failure(anyNSError()))

        expect(sut, toCompleteWith: .failure(anyNSError()))
    }

    // MARK: - Helper
   
    private func makeSUT(primaryResult: OrdersLoader.Result, fallbackResult: OrdersLoader.Result, file: StaticString = #file, line: UInt = #line) -> OrdersLoader {
        let primaryLoader = OrdersLoaderStub(result: primaryResult)
        let fallbackLoader = OrdersLoaderStub(result:fallbackResult)
        
        let sut = OrdersLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        trackForMemoryLeaks(primaryLoader, file: file, line: line)
        trackForMemoryLeaks(fallbackLoader, file: file, line: line)
        trackForMemoryLeaks(fallbackLoader, file: file, line: line)
        
        return sut
    }
}

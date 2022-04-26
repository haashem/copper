//
//  OrdersLoaderCacheDecoratorTests.swift
//  CopperApp
//
//  Created by Hashem Abounajmi on 26/04/2022.
//

import XCTest
import Orders
import OrdersiOS
import CopperApp

class OrdersLoaderCacheDecoratorTests: XCTestCase, OrdersLoaderTestCase {
    
    func test_load_deliversOrdersOnLoaderSuccess() {
        let orders = uniqueOrders()
        let sut = makeSUT(loaderResult: .success(orders))
        expect(sut, toCompleteWith: .success(orders))
    }
    
    func test_load_deliversErrorOnLoaderFailure() {
        let sut = makeSUT(loaderResult: .failure(anyNSError()))
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    func test_load_cachesOrdersOnLoaderSuccess() {
        let orders = uniqueOrders()
        let cacheSpy = CacheSpy()
        let sut = makeSUT(loaderResult: .success(orders), cache: cacheSpy)
        sut.load(){ _ in }
        
        XCTAssertEqual(cacheSpy.messages, [.save(orders)])
    }
    
    func test_load_doesNotCacheOrdersOnLoaderFailure() {
        let cacheSpy = CacheSpy()
        let sut = makeSUT(loaderResult: .failure(anyNSError()), cache: cacheSpy)
        sut.load(){ _ in }
        
        XCTAssertTrue(cacheSpy.messages.isEmpty, "Expected not to cache feed on load error")
    }
    
    
    // MARK: Helper
    
    private func makeSUT(loaderResult: OrdersLoader.Result, cache: CacheSpy = .init(), file: StaticString = #file, line: UInt = #line) -> OrdersLoaderCacheDecorator {
        let loader = OrdersLoaderStub(result: loaderResult)
        let sut = OrdersLoaderCacheDecorator(decoratee: loader, cache: cache)
        
        trackForMemoryLeaks(loader)
        trackForMemoryLeaks(sut)
        return sut
    }
    
    private class CacheSpy: OrdersCache {
        var messages = [Message]()
        
        enum Message: Equatable {
            case save([OrderItem])
        }
        
        func save(_ feed: [OrderItem], completion: @escaping (OrdersCache.Result) -> Void) {
            messages.append(.save(feed))
            completion(.success(()))
        }
    }
}

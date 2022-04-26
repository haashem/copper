//
//  LoadFromCacheUseCaseTest.swift
//  OrdersTests
//
//  Created by Hashem Abounajmi on 24/04/2022.
//

import XCTest
import Orders

class LoadFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCachRetreival() {
        let (sut, store) = makeSut()
        sut.load{_ in}
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSut()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }
    
    func test_load_deliversNoOrderOnEmptyCache() {
        let (sut, store) = makeSut()
        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }
    
    func test_load_deliversNoOrderOnInvalidCache() {
        let (sut, store) = makeSut()
        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrievalWithInvalidCache()
        })
    }
    
    func test_load_deliversCachedOrders() {
        let (sut, store) = makeSut()
        let feed = uniqueOrders()
        
        expect(sut, toCompleteWith: .success(feed.models), when: {
            store.completeRetrieval(with: feed.local)
        })
    }

    func test_load_hasNoSideEffectsOnRetrievalError() {
        let (sut, store) = makeSut()
        
        sut.load{ _ in }
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnEmptyCache() {
        let (sut, store) = makeSut()
        
        sut.load{ _ in }
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = OrdersStoreSpy()
        var sut: LocalOrdersLoader? = LocalOrdersLoader(store: store)
        
        var receivedResults = [LocalOrdersLoader.LoadResult]()
        sut?.load { receivedResults.append($0) }
        sut = nil
        
        store.completeRetrievalWithEmptyCache()
        XCTAssertTrue(receivedResults.isEmpty)
    }
    // MARK: - Helpers
    
    private func expect(_ sut: LocalOrdersLoader, toCompleteWith expectedResult: LocalOrdersLoader.LoadResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedOrders), .success(expectedOrders)):
                XCTAssertEqual(receivedOrders, expectedOrders, file: file, line: line)
            case let (.failure(recievedError), .failure(expectedError)):
                XCTAssertEqual(recievedError as NSError, expectedError as NSError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeSut(file: StaticString = #file, line: UInt = #line) -> (sut: LocalOrdersLoader, store: OrdersStoreSpy) {
        let store = OrdersStoreSpy()
        let sut = LocalOrdersLoader(store: store)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
}


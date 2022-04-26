//
//  CacheFeedUseCaseTests.swift
//  OrdersTests
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import XCTest
import Orders

class CacheOrdersUseCaseTests: XCTestCase {


    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestsNewCacheInsertion() {

        let (sut, store) = makeSut()
        let items = uniqueOrders()
        sut.save(items.models) {_ in }
        
        XCTAssertEqual(store.receivedMessages, [.insert(items.local)])
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSut()
        let insertionError = anyNSError()
        expect(sut, toCompleteWithError: insertionError, when: {
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_save_successOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSut()
        
        expect(sut, toCompleteWithError: nil, when: {
            store.completeInsertionSuccessfully()
        })
    }
    
    func test_save_doesNotDeliverInsertionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = OrdersStoreSpy()
        var sut: LocalOrdersLoader? = LocalOrdersLoader(store: store)
        var receivedResults = [LocalOrdersLoader.SaveResult]()
        sut?.save(uniqueOrders().models) { receivedResults.append($0)}
        
        sut = nil
        store.completeInsertion(with: anyNSError())
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #file, line: UInt = #line) -> (sut: LocalOrdersLoader, store: OrdersStoreSpy) {
        let store = OrdersStoreSpy()
        let sut = LocalOrdersLoader(store: store)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalOrdersLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "wait for save completion")
        
        var receivedError: Error?
        sut.save(uniqueOrders().models) { result in
            if case let Result.failure(error) = result { receivedError = error }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: UInt(line))
    }
}

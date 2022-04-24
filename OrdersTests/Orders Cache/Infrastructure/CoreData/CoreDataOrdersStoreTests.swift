//
//  CoreDataOrdersStoreTests.swift
//  OrdersTests
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import XCTest
import Orders

class CoreDataFeedStoreTests: XCTestCase {

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        expect(sut, toRetrieve: .success(.none))
    }

    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        expect(sut, toRetrieve: .success(.none))
    }

    func test_retrieveـdeliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()

        let orders = uniqueOrders().local

        insert(orders, to: sut)

        expect(sut, toRetrieve: .success(orders))
    }

    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()

        let orders = uniqueOrders().local
        insert(orders, to: sut)
        expect(sut, toRetrieveTwice: .success(orders))
    }

    func test_insert_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        let insertionError = insert(uniqueOrders().local, to: sut)
        XCTAssertNil(insertionError, "Expected to insert cache successfully")
    }

    func test_insert_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        insert(uniqueOrders().local, to: sut)
        let insertionError = insert(uniqueOrders().local, to: sut)
        XCTAssertNil(insertionError, "Expected to override cache successfully")
    }

    func test_insert_overridePreviouslyInsertedCacheValues() {
        let sut = makeSUT()
        insert(uniqueOrders().local, to: sut)
        let latestFeed = uniqueOrders().local
        insert(latestFeed, to: sut)
        expect(sut, toRetrieve: .success(latestFeed))
    }
    
    // Helpers
    
    @discardableResult
    func insert(_ cache: [LocalOrderItem], to sut: OrdersStore) -> Error? {
       
       let exp = expectation(description: "Wait for cache inserion")
       var insertionError: Error?
       sut.insert(cache) { result in
        if case let Result.failure(error) = result { insertionError = error }
           exp.fulfill()
       }
       wait(for: [exp], timeout: 1.0)
       
        return insertionError
    }

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> OrdersStore {
        
         let storeURL = URL(fileURLWithPath: "/dev/null")
         let sut = try! CoreDataOrdersStore(storeURL: storeURL)
         trackForMemoryLeaks(sut, file: file, line: line)
         return sut
     }
    
    func expect(_ sut: OrdersStore, toRetrieveTwice expectedResult: OrdersStore.RetrievalResult, file: StaticString = #file, line: UInt = #line) {
       expect(sut, toRetrieve: expectedResult, file: file, line: line)
       expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    func expect(_ sut: OrdersStore, toRetrieve expectedResult: OrdersStore.RetrievalResult, file: StaticString = #file, line: UInt = #line) {
       let exp = expectation(description: "Wait for cache retrieval")
       
       sut.retrieve{ retrievedResult in
           switch (retrievedResult, expectedResult) {
           case (.success(.none), .success(.none)),
                (.failure, .failure):
               break
           case let (.success(.some(expectedCache)), .success(.some(retrievedCache))):
            XCTAssertEqual(expectedCache, retrievedCache, file: file, line: line)
           default:
               XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
           }
           exp.fulfill()
       }
       wait(for: [exp], timeout: 1.0)
    }
}

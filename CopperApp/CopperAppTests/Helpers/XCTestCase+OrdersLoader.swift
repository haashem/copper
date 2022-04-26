//
//  XCTestCase+OrdersLoader.swift
//  CopperAppTests
//
//  Created by Hashem Abounajmi on 25/04/2022.
//

import XCTest
import Orders
protocol OrdersLoaderTestCase: XCTestCase {}

extension OrdersLoaderTestCase {
    func expect(_ sut: OrdersLoader, toCompleteWith expectedResult: OrdersLoader.Result, file:  StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "wait for load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedOrders), .success(expectedOrders)):
                XCTAssertEqual(receivedOrders, expectedOrders)
            case (.failure, .failure):
                break
                
            default:
                XCTFail("expected \(expectedResult) load feed result, got \(receivedResult) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
}

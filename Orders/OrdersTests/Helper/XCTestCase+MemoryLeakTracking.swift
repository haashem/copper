//
//  XCTestCase+MemoryLeakTracking.swift
//  OrdersTests
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: #file, line: #line)
        }
    }
}

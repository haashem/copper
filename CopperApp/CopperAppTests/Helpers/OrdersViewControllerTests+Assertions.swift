//
//  OrdersViewControllerTests+Assertions.swift
//  CopperAppTests
//
//  Created by Hashem Abounajmi on 25/04/2022.
//

import XCTest
import Foundation
import Orders
import OrdersiOS

extension OrdersUIIntegrationTests {
 
    func assertThat(_ sut: OrdersViewController, isRendering orders: [OrderItemViewModel], file: StaticString = #file, line: UInt = #line) {
        sut.view.enforceLayoutCycle()
        
        guard sut.numberOfRenderedOrdersCells() == orders.count else {
            return XCTFail("Expected \(orders.count) order item, got \(sut.numberOfRenderedOrdersCells()) instead.", file: file, line: line)
        }
        
        orders.enumerated().forEach { index, order in
            assertThat(sut, hasViewConfiguredFor: order, at: index, file: file, line: line)
        }
    }
    
    func assertThat(_ sut: OrdersViewController, hasViewConfiguredFor order: OrderItemViewModel, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.orderCell(at: index)
        
        guard let cell = view as? OrderItemCell else {
            return XCTFail("Expected \(OrderItemCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        XCTAssertEqual(cell.transactionLabelText, order.transaction, "Expected transacttion text to be \(String(describing: order.transaction)) for order cell at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.amountText, order.amount, "Expected amount text to be \(String(describing: order.amount)) for order cell at index (\(index)", file: file, line: line)
        
        XCTAssertEqual(cell.dateText, order.date, "Expected date text to be \(String(describing: order.date)) for order cell at index (\(index)", file: file, line: line)
        
        XCTAssertEqual(cell.statusText, order.status, "Expected status text to be \(String(describing: order.status)) for order cell at index (\(index)", file: file, line: line)
    }
}

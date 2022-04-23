//
//  OrdersTests.swift
//  OrdersTests
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import XCTest
import Orders

class OrdersTests: XCTestCase {

    func test_init_doesntRequestURL() {
        let client = HTTPClientSpy()
        _ = makeSUT()
        
        XCTAssertTrue(client.messages.isEmpty)
    }
    
    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "https://example.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load{_ in }
        sut.load{_ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        let givenError = NSError(domain: "test", code: 0, userInfo: nil)
        
        expect(sut, toCompleteWithResult:
            failure(.connectivity), when: {
            client.complete(with: givenError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        
        let (sut, client) = makeSUT()
       
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { (arg) in
            
            let (index, code) = arg
            expect(sut, toCompleteWithResult:
                failure(.invalidData), when: {
                let json = makeItemJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_givenEmptyResponse_callsCompletionWithEmptyList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .success([]), when: {
            let emptyListJSON = makeItemJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_when200HTTPResponseWithInvalidData_deliversError() {
        
        // given
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult:
            failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_whenValidJSONdata_callCompletionWithFeedItems() {
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(id: "9f843fb7749377ecc415d3cacd7bf76f", currency: "BTC", amount: 2.31, orderType: .deposit, orderStatus: .processing, createdAt: (Date(timeIntervalSince1970: 1619649050), 1619649050951))
        let item2 = makeItem(id: "fbead4a35338e4a7baefab259c2a7fe5", currency: "ETH", amount: 12.8972, orderType: .withdraw, orderStatus: .canceled, createdAt: (Date(timeIntervalSince1970: 1594908768), 1594908768836))

        let itemsJSON = makeItemJSON([item1.json, item2.json])

        expect(sut, toCompleteWithResult: .success([item1.model, item2.model]), when: {
            client.complete(withStatusCode: 200, data: itemsJSON)
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTinstanceHasBeenDeallocated() {
        let url = URL(string: "http://example.com")!
        let client = HTTPClientSpy()
        var sut: RemoteOrdersLoader? = RemoteOrdersLoader(url: url, client: client)
        
        var capturedResults = [RemoteOrdersLoader.Result]()
        
        sut?.load {
            capturedResults.append($0)
        }
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemJSON([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    
    // MARK: Helper
    
    private func makeItem(id: String, currency: String, amount: Decimal, orderType: OrderType, orderStatus: OrderStatus, createdAt: (date: Date, timestamp: Double)) -> (model: OrderItem, json: [String: Any]) {
        
        let item = OrderItem(id: id, currency: currency, amount: amount, orderType: orderType, orderStatus: orderStatus, createdAt: createdAt.date)
        
        let json = [
            "orderId": item.id.description,
            "currency": item.currency,
            "amount": "\(item.amount)",
            "orderType": item.orderType.rawValue,
            "orderStatus": item.orderStatus.rawValue,
            "createdAt": "\(createdAt.timestamp)"
            ]
        
        return (item, json)
    }

    private func makeItemJSON(_ items: [[String: Any]]) -> Data {
        let json = ["orders": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func makeSUT(url: URL = URL(string: "https://example.com")!) -> (RemoteOrdersLoader, HTTPClientSpy) {
        
        let client = HTTPClientSpy()
        let sut = RemoteOrdersLoader(url: url, client: client)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteOrdersLoader, toCompleteWithResult expectedResult: RemoteOrdersLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "wait for load completion")
        sut.load { receivedResult in
            
            switch (receivedResult, expectedResult) {
                case let (.success(receivedItems), .success(expectedItems)):
                    XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                case let (.failure(receivedError as RemoteOrdersLoader.Error), .failure(expectedError as RemoteOrdersLoader.Error)):
                    XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                default:
                    XCTFail("Expected \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1)
    }
    
    private func failure(_ error: RemoteOrdersLoader.Error) -> RemoteOrdersLoader.Result {
        return .failure(error)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success((data, response)))
        }
    }
}

private extension OrderType  {
    var rawValue: String {
        switch self {
        case .sell:
            return "sell"
        case .buy:
            return "buy"
        case .withdraw:
            return "withdraw"
        case .deposit:
            return "deposit"
        }
    }
}

private extension OrderStatus  {
    var rawValue: String {
        switch self {
        case .executed:
            return "executed"
        case .approved:
            return "approved"
        case .canceled:
            return "canceled"
        case .processing:
            return "processing"
        }
    }
}


//
//  OrdersStoreSpy.swift
//  OrdersTests
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import Foundation
import Orders

class OrdersStoreSpy: OrdersStore {
    
    enum ReceivedMessage: Equatable {
        case insert([LocalOrderItem])
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()

    private var insertionsCompletions = [InsertionCompletion]()
    private var retreivalCompletions = [RetrievalCompletion]()
    
    func completeInsertion(with error: NSError, at index: Int = 0) {
        insertionsCompletions[index](.failure(error))
    }
    
    func insert(_ orders: [LocalOrderItem], insertionCompletion: @escaping InsertionCompletion) {
        insertionsCompletions.append(insertionCompletion)
        receivedMessages.append(.insert(orders))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionsCompletions[index](.success(()))
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        retreivalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    func completeRetrieval(with error: NSError, at index: Int = 0) {
        retreivalCompletions[index](.failure(error))
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retreivalCompletions[index](.success(.none))
    }
    
    func completeRetrieval(with orders: [LocalOrderItem], at index: Int = 0) {
        retreivalCompletions[index](.success(orders))
    }
}

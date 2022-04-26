//
//  MainQueueDispatchDecorator.swift
//  CopperApp
//
//  Created by Hashem Abounajmi on 25/04/2022.
//

import Foundation
import Orders

final class MainQueueDispatchDecorater<T> {
    private let decoratee: T
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async {
                completion()
            }
        }
        completion()
    }
}

extension MainQueueDispatchDecorater: OrdersLoader where T == OrdersLoader {
    func load(completion: @escaping (OrdersLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}

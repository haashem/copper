//
//  SharedTestHelpers.swift
//  OrdersTests
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain:"any error", code: 0, userInfo: nil)
}

func anyURL() ->URL {
    return URL(string: "https://any-url.com")!
}

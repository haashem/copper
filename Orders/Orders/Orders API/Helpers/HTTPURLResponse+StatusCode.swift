//
//  HTTPURLResponse+StatusCode.swift
//  Orders
//
//  Created by Hashem Abounajmi on 23/04/2022.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isHTTPURLResponseOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}

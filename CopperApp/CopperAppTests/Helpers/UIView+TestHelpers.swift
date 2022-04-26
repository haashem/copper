//
//  UIView+TestHelpers.swift
//  CopperAppTests
//
//  Created by Hashem Abounajmi on 25/04/2022.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}

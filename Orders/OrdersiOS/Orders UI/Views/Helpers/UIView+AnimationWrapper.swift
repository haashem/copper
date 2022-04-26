//
//  UIView+AnimationWrapper.swift
//  OrdersiOS
//
//  Created by Hashem Abounajmi on 25/04/2022.
//

import UIKit

public protocol UIViewAnimationsWrapper: AnyObject {

    static func animate(withDuration duration: TimeInterval, animations: @escaping () -> Void, completion: ((Bool) -> Void)?)
}

extension UIView: UIViewAnimationsWrapper {}

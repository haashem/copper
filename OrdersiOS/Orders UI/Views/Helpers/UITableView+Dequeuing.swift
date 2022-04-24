//
//  UITableView+Dequeing.swift
//  OrdersiOS
//
//  Created by Hashem Abounajmi on 24/04/2022.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}

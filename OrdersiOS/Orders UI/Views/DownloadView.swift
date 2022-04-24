//
//  DownloadView.swift
//  OrdersiOS
//
//  Created by Hashem Abounajmi on 24/04/2022.
//

import UIKit

final public class DownloadView: UIView {
    @IBOutlet private(set) public var downloadButton: UIButton!
    @IBOutlet private(set) public var activityIndicator: UIActivityIndicatorView!
    
    public func beginRefreshing() {
        downloadButton.isHidden = true
        activityIndicator.startAnimating()
    }
    
    public func endRefreshing() {
        downloadButton.isHidden = false
        activityIndicator.stopAnimating()
    }
}

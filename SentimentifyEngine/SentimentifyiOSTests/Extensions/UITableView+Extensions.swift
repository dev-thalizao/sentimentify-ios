//
//  UITableView+Extensions.swift
//  SentimentifyiOSTests
//
//  Created by Thales Frigo on 25/04/21.
//

import UIKit

extension UITableView {
    
    func cell(indexPath: IndexPath) -> UITableViewCell? {
        return dataSource?.tableView(self, cellForRowAt: indexPath)
    }
    
    func select(indexPath: IndexPath) {
        delegate?.tableView?(self, didSelectRowAt: indexPath)
    }
}

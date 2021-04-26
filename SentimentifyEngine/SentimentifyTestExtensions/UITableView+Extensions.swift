//
//  UITableView+Extensions.swift
//  SentimentifyTestExtensions
//
//  Created by Thales Frigo on 26/04/21.
//

import UIKit

public extension UITableView {
    
    func cell(indexPath: IndexPath) -> UITableViewCell? {
        return dataSource?.tableView(self, cellForRowAt: indexPath)
    }
    
    func select(indexPath: IndexPath) {
        delegate?.tableView?(self, didSelectRowAt: indexPath)
    }
}

//
//  CellController.swift
//  SentimentifyiOS
//
//  Created by Thales Frigo on 25/04/21.
//

import UIKit

final class SectionController {

    let id: AnyHashable
    let dataSource: UITableViewDataSource
    let delegate: UITableViewDelegate?
    
    init(id: AnyHashable, dataSource: UITableViewDataSource, delegate: UITableViewDelegate? = nil) {
        self.id = id
        self.dataSource = dataSource
        self.delegate = delegate
    }
}

extension SectionController: Equatable {
    
    public static func == (lhs: SectionController, rhs: SectionController) -> Bool {
        lhs.id == rhs.id
    }
}

extension SectionController: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

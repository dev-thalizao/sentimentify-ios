//
//  SearchResultCellController.swift
//  SentimentifyiOS
//
//  Created by Thales Frigo on 25/04/21.
//

import UIKit
import SentimentifyEngine

final class SearchResultCellController: NSObject {

    private let viewModel: SearchResultViewModel
    private let selection: (SearchResultViewModel) -> Void
    private var cell: SearchResultCell?
    
    init(viewModel: SearchResultViewModel, selection: @escaping (SearchResultViewModel) -> Void) {
        self.viewModel = viewModel
        self.selection = selection
    }
}

extension SearchResultCellController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.textLabel?.text = viewModel.title
        cell?.detailTextLabel?.text = viewModel.subtitle
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection(viewModel)
    }
}

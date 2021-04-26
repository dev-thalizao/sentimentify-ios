//
//  SearchResultCellController.swift
//  SentimentifyiOS
//
//  Created by Thales Frigo on 25/04/21.
//

import UIKit
import Kingfisher
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
        cell?.userImageView.kf.setImage(with: viewModel.image)
        cell?.userNameLabel.text = viewModel.title
        cell?.screenNameLabel.text = viewModel.subtitle
        cell?.contentLabel.text = viewModel.content
        cell?.createdAtLabel.text = viewModel.createdAtReadable
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selection(viewModel)
    }
}

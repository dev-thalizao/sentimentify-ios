//
//  SearchViewController.swift
//  SentimentifyiOS
//
//  Created by Thales Frigo on 25/04/21.
//

import UIKit
import SentimentifyEngine

public final class SearchViewController: UITableViewController {
    
    private lazy var errorViewController = ErrorViewController()
    
    public typealias OnSearch = (String) -> Void
    
    public let onSearch: OnSearch
    
    public init(onSearch: @escaping SearchViewController.OnSearch) {
        self.onSearch = onSearch
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        refreshControl = UIRefreshControl()
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        searchController.searchBar.text.flatMap(onSearch)
    }
}

extension SearchViewController: LoadingView {
    
    public func display(viewModel: LoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
}

extension SearchViewController: ErrorView {
    
    public func display(viewModel: ErrorViewModel) {
        errorViewController.onRetry = { errorVC in
            errorVC.remove()
        }
        errorViewController.errorMessage = viewModel.message
        add(errorViewController)
    }
}

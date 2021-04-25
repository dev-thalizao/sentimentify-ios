//
//  SearchViewController.swift
//  SentimentifyiOS
//
//  Created by Thales Frigo on 25/04/21.
//

import UIKit
import SentimentifyEngine

public final class SearchViewController: UIViewController {
    
    public typealias OnSearch = (String) -> Void
    public typealias OnSelection = (SearchResultViewModel) -> Void
    
    public let onSearch: OnSearch
    public let onSelection: OnSelection
    
    private lazy var loadingViewController = LoadingViewController()
    private lazy var errorViewController = ErrorViewController()
    private lazy var resultsViewController = DiffableTableViewController()
    
    private lazy var results = [SearchResultViewModel]()
    
    public init(onSearch: @escaping OnSearch, onSelection: @escaping OnSelection) {
        self.onSearch = onSearch
        self.onSelection = onSelection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        add(resultsViewController)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        searchController.searchBar.text.flatMap(onSearch)
    }
}

extension SearchViewController: LoadingView {
    
    public func display(viewModel: LoadingViewModel) {
        loadingViewController.isLoading = viewModel.isLoading
        if viewModel.isLoading {
            add(loadingViewController)
        } else {
            loadingViewController.remove()
        }
    }
}

extension SearchViewController: ErrorView {
    
    public func display(viewModel: ErrorViewModel) {
        // TODO: - Clear the results
        
        
        
        errorViewController.onRetry = { errorVC in
            errorVC.remove()
            // TODO: - Call the same search here
        }
        errorViewController.errorMessage = viewModel.message
        add(errorViewController)
    }
}

extension SearchViewController: SearchView {
    
    public func display(viewModel: SearchViewModel) {
        results.append(contentsOf: viewModel.results)
        
        var sections = results.compactMap { [onSelection] result -> SectionController in
            let controller = SearchResultCellController(viewModel: result) { (viewModel) in
                onSelection(viewModel)
            }
            
            return SectionController(id: result, dataSource: controller, delegate: controller)
        }
        
        if let nextResults = viewModel.nextResults {
            let controller = NextResultsCellController(callback: nextResults)
            sections.append(SectionController(id: UUID(), dataSource: controller, delegate: controller))
        }
        
        resultsViewController.display(sections)
    }
}

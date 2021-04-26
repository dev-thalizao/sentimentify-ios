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
    
    public var onSearch: OnSearch?
    public var onSelection: OnSelection?
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    private lazy var loadingViewController = LoadingViewController()
    private lazy var emptyViewController = EmptyViewController()
    private lazy var resultsViewController = DiffableTableViewController()
    
    private lazy var currentResults = [SearchResultViewModel: SectionController]()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureInitialState()
    }
    
    private func configureInitialState() {
        add(emptyViewController)
        emptyViewController.message = "Você está pronto para analisar os sentimentos dos tweets de seus amigos? Basta digitar o nome de usuário e selecionar um tweet!"
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Pesquisar"
        searchController.searchBar.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Sentimentify"
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        if !text.isEmpty {
            currentResults.removeAll()
            resultsViewController.display([])
            onSearch?(text)
        } else {
            resultsViewController.remove()
            configureInitialState()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
   
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: LoadingView {
    
    public func display(viewModel: LoadingViewModel) {
        emptyViewController.remove()
        
        guard currentResults.isEmpty else { return }
        
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
        guard let message = viewModel.message else { return }
        
        let alertVC = UIAlertController(title: "Ops", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertVC.addAction(action)
        
        present(alertVC, animated: true)
    }
}

extension SearchViewController: SearchView {
 
    public func display(viewModel: SearchViewModel) {
        guard !viewModel.results.isEmpty else {
            resultsViewController.remove()
            emptyViewController.message = "Nenhum resultado encontrado."
            add(emptyViewController)
            return
        }
        
        emptyViewController.remove()
        add(resultsViewController)
    
        viewModel.results.forEach { [onSelection] (result) in
            let controller = SearchResultCellController(viewModel: result) { (viewModel) in
                onSelection?(viewModel)
            }
            currentResults[result] = SectionController(id: result, dataSource: controller, delegate: controller)
        }

        let results = currentResults.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.key.createdAt > rhs.key.createdAt
        }).map(\.value)
        
        guard let nextResults = viewModel.nextResults else {
            resultsViewController.display(results)
            return
        }
        
        let controller = NextResultsCellController(callback: nextResults)
        let nextResultsSection = SectionController(id: UUID(), dataSource: controller, delegate: controller)
    
        resultsViewController.display(results + [nextResultsSection])
    }
}

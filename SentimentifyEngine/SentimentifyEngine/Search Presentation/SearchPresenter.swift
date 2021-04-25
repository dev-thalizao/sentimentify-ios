//
//  SearchPresenter.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 23/04/21.
//

import Foundation

public protocol SearchView {
    func display(viewModel: SearchViewModel)
}

public final class SearchPresenter: SearchUseCaseOutput {

    private let loadingView: LoadingView
    private let errorView: ErrorView
    private let searchView: SearchView
    
    public init(loadingView: LoadingView, errorView: ErrorView, searchView: SearchView) {
        self.loadingView = loadingView
        self.errorView = errorView
        self.searchView = searchView
    }
    
    public func didStartSearching() {
        loadingView.display(viewModel: .init(isLoading: true))
        errorView.display(viewModel: .init(message: nil))
    }
    
    public func didFinishSearch(with results: SearchResults) {
        loadingView.display(viewModel: .init(isLoading: false))
        searchView.display(viewModel: .map(results))
    }
    
    public func didFinishSearch(with error: Error) {
        loadingView.display(viewModel: .init(isLoading: false))
        errorView.display(viewModel: .init(message: error.localizedDescription))
    }
}

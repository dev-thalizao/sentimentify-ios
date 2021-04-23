//
//  SearchPresenter.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 23/04/21.
//

import Foundation

public protocol LoadingView {
    func display(viewModel: LoadingViewModel)
}

public struct LoadingViewModel: Equatable {
    public let isLoading: Bool
    
    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }
}

public protocol ErrorView {
    func display(viewModel: ErrorViewModel)
}

public struct ErrorViewModel: Equatable {
    public let message: String?
    
    public init(message: String?) {
        self.message = message
    }
}

public protocol SearchView {
    func display(viewModel: SearchViewModel)
}

public struct SearchViewModel: Equatable {
    public let results: [SearchResultViewModel]
    
    public static func map(
        _ results: [SearchResult],
        currentDate: Date = .init(),
        calendar: Calendar = .current,
        locale: Locale = .current
    ) -> SearchViewModel {
        let formatter = RelativeDateTimeFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        
        return SearchViewModel(results: results.map({ result in
            SearchResultViewModel(
                title: result.author.name,
                subtitle: result.author.username,
                content: result.content.text,
                image: result.author.photo,
                createdAt: formatter.localizedString(
                    for: result.content.createdAt,
                    relativeTo: currentDate
                )
            )
        }))
    }
}

public struct SearchResultViewModel: Equatable {
    public let title: String
    public let subtitle: String
    public let content: String
    public let image: URL?
    public let createdAt: String
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
    
    public func didFinishSearch(with results: [SearchResult]) {
        loadingView.display(viewModel: .init(isLoading: false))
        searchView.display(viewModel: .map(results))
    }
    
    public func didFinishSearch(with error: Error) {
        loadingView.display(viewModel: .init(isLoading: false))
        errorView.display(viewModel: .init(message: error.localizedDescription))
    }
}

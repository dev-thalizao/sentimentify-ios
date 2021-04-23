//
//  SearchPresenterTests.swift
//  SentimentifyEngineTests
//
//  Created by Thales Frigo on 23/04/21.
//

import XCTest
@testable import SentimentifyEngine

final class SearchPresenterTests: XCTestCase {

    func testPresenterTriggerLoadingAndRemoveError() {
        let view = ViewSpy()
        let sut = SearchPresenter(loadingView: view, errorView: view, searchView: view)
        
        sut.didStartSearching()
        
        XCTAssertEqual(
            view.messages,
            [.loading(.init(isLoading: true)), .error(.init(message: nil))]
        )
    }
    
    func testPresenterRemoveLoadingAndPresentError() {
        let view = ViewSpy()
        let sut = SearchPresenter(loadingView: view, errorView: view, searchView: view)
        
        sut.didFinishSearch(with: NSError(domain: "offline", code: -222))
        
        XCTAssertEqual(
            view.messages,
            [
                .loading(.init(isLoading: false)),
                .error(.init(message: "The operation couldn’t be completed. (offline error -222.)"))
            ]
        )
    }
    
    func testPresenterRemoveLoadingAndPresentResult() {
        let view = ViewSpy()
        let sut = SearchPresenter(loadingView: view, errorView: view, searchView: view)
    
        sut.didFinishSearch(with: anySearchResults())
        
        XCTAssertEqual(
            view.messages,
            [
                .loading(.init(isLoading: false)),
                .search(SearchViewModel.map(anySearchResults()))
            ]
        )
    }
}

private final class ViewSpy {
    private(set) var messages = [SearchPresenterViewMessages]()
}

extension ViewSpy: LoadingView {
    
    func display(viewModel: LoadingViewModel) {
        messages.append(.loading(viewModel))
    }
}

extension ViewSpy: ErrorView {
    
    func display(viewModel: ErrorViewModel) {
        messages.append(.error(viewModel))
    }
}

extension ViewSpy: SearchView {
    
    func display(viewModel: SearchViewModel) {
        messages.append(.search(viewModel))
    }
}

enum SearchPresenterViewMessages: Equatable {
    case loading(LoadingViewModel)
    case error(ErrorViewModel)
    case search(SearchViewModel)
    
    static func == (lhs: SearchPresenterViewMessages, rhs: SearchPresenterViewMessages) -> Bool {
        switch (lhs, rhs) {
        case (let .loading(lhsViewModel), let .loading(rhsViewModel)):
            return lhsViewModel == rhsViewModel
        case (let .error(lhsViewModel), let .error(rhsViewModel)):
            return lhsViewModel == rhsViewModel
        case (let .search(lhsViewModel), let .search(rhsViewModel)):
            return lhsViewModel == rhsViewModel
        default:
            return false
        }
    }
}

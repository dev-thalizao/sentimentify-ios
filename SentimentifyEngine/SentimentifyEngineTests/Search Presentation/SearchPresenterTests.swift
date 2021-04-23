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
        let (sut, view) = makeSUT()
        
        sut.didStartSearching()
        
        XCTAssertEqual(
            view.messages,
            [.loading(.init(isLoading: true)), .error(.init(message: nil))]
        )
    }
    
    func testPresenterRemoveLoadingAndPresentError() {
        let (sut, view) = makeSUT()
        
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
        let (sut, view) = makeSUT()
        
        sut.didFinishSearch(with: anySearchResults())
        
        XCTAssertEqual(
            view.messages,
            [
                .loading(.init(isLoading: false)),
                .search(.map(anySearchResults()))
            ]
        )
    }
    
    private func makeSUT() -> (sut: SearchPresenter, view: SearchViewSpy) {
        let view = SearchViewSpy()
        let sut = SearchPresenter(loadingView: view, errorView: view, searchView: view)
        trackForMemoryLeaks(view)
        trackForMemoryLeaks(sut)
        return (sut, view)
    }
}

private final class SearchViewSpy: SearchView, LoadingView, ErrorView {
    
    private(set) var messages = [SearchPresenterMessage]()
    
    func display(viewModel: LoadingViewModel) {
        messages.append(.loading(viewModel))
    }
    
    func display(viewModel: ErrorViewModel) {
        messages.append(.error(viewModel))
    }
    
    func display(viewModel: SearchViewModel) {
        messages.append(.search(viewModel))
    }
}

private enum SearchPresenterMessage: Equatable {
    case loading(LoadingViewModel)
    case error(ErrorViewModel)
    case search(SearchViewModel)
    
    static func == (lhs: SearchPresenterMessage, rhs: SearchPresenterMessage) -> Bool {
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

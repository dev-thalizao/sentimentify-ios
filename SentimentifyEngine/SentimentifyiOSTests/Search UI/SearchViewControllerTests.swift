//
//  SearchViewControllerTests.swift
//  SentimentifyiOSTests
//
//  Created by Thales Frigo on 25/04/21.
//

import XCTest
import SentimentifyEngine
import SentimentifyTestExtensions
@testable import SentimentifyiOS

final class SearchViewControllerTests: XCTestCase {

    func testOnSearchIsCalledBySearchController() {
        var calls = 0
        var receivedInput: String?
        
        let sut = makeSUT(onSearch: { input in
            calls += 1
            receivedInput = input
        })
        
        let search = UISearchController()
        search.searchBar.text = "thalesfrigo"
        
        sut.updateSearchResults(for: search)
        
        XCTAssertEqual(calls, 1)
        XCTAssertEqual(receivedInput, "thalesfrigo")
    }
    
    func testLoadingViewMethods() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false, "Should start false")
        
        sut.display(viewModel: LoadingViewModel(isLoading: true))
        
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
        
        sut.display(viewModel: LoadingViewModel(isLoading: false))
        
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
    }
    
    func testErrorViewMethods() throws {
        let sut = makeSUT()
        
        sut.display(viewModel: ErrorViewModel(message: "Não foi possível completar a operação."))
        
        let errorVC = try XCTUnwrap(sut.children.last as? ErrorViewController)
        
        errorVC.retryButton.simulate(event: .touchUpInside)
        
        XCTAssertNil(errorVC.parent)
    }
    
    private func makeSUT(onSearch: @escaping SearchViewController.OnSearch = { _ in }) -> SearchViewController {
        let sut = SearchViewController(onSearch: onSearch)
        trackForMemoryLeaks(sut)
        return sut
    }
}

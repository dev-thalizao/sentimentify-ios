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
    
    func testLoadingViewMethods() throws {
        let sut = makeSUT()
        
        sut.display(viewModel: LoadingViewModel(isLoading: true))
        
        let loadingVC = try XCTUnwrap(sut.children.first as? LoadingViewController)
        
        XCTAssertEqual(loadingVC.isLoading, true)
        
        sut.display(viewModel: LoadingViewModel(isLoading: false))
        
        XCTAssertEqual(loadingVC.isLoading, false)
        XCTAssertNil(loadingVC.parent)
    }
    
    func testErrorViewMethods() throws {
        let sut = makeSUT()
        
        sut.display(viewModel: ErrorViewModel(message: "Não foi possível completar a operação."))
        
        let errorVC = try XCTUnwrap(sut.children.first as? ErrorViewController)
        
        errorVC.retryButton.simulate(event: .touchUpInside)
        
        XCTAssertNil(errorVC.parent)
    }
    
    func testSearchViewMethods() throws {
        let sut = makeSUT()
        var calls = 0
        
        _ = sut.view
        
        sut.display(viewModel: .map(anySearchResults(10, next: { calls += 1 })))
        
        let resultVC = try XCTUnwrap(sut.children.last as? DiffableTableViewController)
        
        (0..<10).forEach { (row) in
            XCTAssertTrue(resultVC.tableView.cell(indexPath: .init(row: row, section: 0)) is SearchResultCell)
        }
        XCTAssertTrue(resultVC.tableView.cell(indexPath: .init(row: 10, section: 0)) is NextResultsCell)
        XCTAssertEqual(calls, 1)
    }
    
    private func makeSUT(
        onSearch: @escaping SearchViewController.OnSearch = { _ in },
        onSelection: @escaping SearchViewController.OnSelection = { _ in }
    ) -> SearchViewController {
        let sut = SearchViewController(onSearch: onSearch, onSelection: onSelection)
        trackForMemoryLeaks(sut)
        return sut
    }
}

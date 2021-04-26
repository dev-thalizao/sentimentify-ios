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
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        
        sut.display(viewModel: ErrorViewModel(message: "Não foi possível completar a operação."))
        
        RunLoop.current.run(until: .init())
        
        let alertVC = try XCTUnwrap(sut.presentedViewController as? UIAlertController)
        
        XCTAssertEqual(alertVC.message, "Não foi possível completar a operação.")
        
        
        alertVC.dismiss(animated: true, completion: nil)
//        alertVC.tapButton(atIndex: 0)
        
        RunLoop.current.run(until: .init())
        
        let exp = expectation(description: "Test after 1.5 second wait")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.5)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNil(sut.presentedViewController)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testSearchViewMethods() throws {
        let sut = makeSUT()
        var calls = 0
        
        _ = sut.view
        
        sut.display(viewModel: .map(anySearchResults(1, next: { calls += 1 })))
        
        let resultVC = try XCTUnwrap(sut.children.last as? DiffableTableViewController)
        
        let dataSource = resultVC.tableView.dataSource as? UITableViewDiffableDataSource<Int, SectionController>
        
        XCTAssertTrue(dataSource?.itemIdentifier(for: .init(row: 0, section: 0))?.dataSource is SearchResultCellController)
        XCTAssertTrue(dataSource?.itemIdentifier(for: .init(row: 1, section: 0))?.dataSource is NextResultsCellController)

        resultVC.tableView.select(indexPath: .init(row: 1, section: 0))
        
        XCTAssertEqual(calls, 1)
    }
    
    private func makeSUT(
        onSearch: @escaping SearchViewController.OnSearch = { _ in },
        onSelection: @escaping SearchViewController.OnSelection = { _ in }
    ) -> SearchViewController {
        let sut = SearchViewController()
        sut.loadViewIfNeeded()
        sut.onSearch = onSearch
        sut.onSelection = onSelection
//        trackForMemoryLeaks(sut)
        return sut
    }
}

private extension UIAlertController {
    typealias AlertHandler = @convention(block) (UIAlertAction) -> Void

    func tapButton(atIndex index: Int) {
        guard let block = actions[index].value(forKey: "handler") else { return }
        let handler = unsafeBitCast(block as AnyObject, to: AlertHandler.self)
        handler(actions[index])
    }
}

//
//  AnalyzeViewControllerTests.swift
//  SentimentifyiOSTests
//
//  Created by Thales Frigo on 26/04/21.
//

import XCTest
import SentimentifyEngine
import SentimentifyTestExtensions
@testable import SentimentifyiOS

final class AnalyzeViewControllerTests: XCTestCase {

    func testOnLoadIsCalledByAnalyzeController() {
        var calls = 0
        
        let sut = makeSUT(onLoad: { calls += 1 })
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(calls, 1)
    }
    
    func testOnCloseIsCalledByAnalyzeController() {
        var calls = 0
        
        let sut = makeSUT(onClose: { _ in calls += 1 })
        
        sut.loadViewIfNeeded()
        let closeButton = sut.navigationItem.rightBarButtonItem!
        
        _ = closeButton.target?.perform(closeButton.action)
        
        XCTAssertEqual(calls, 1)
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
        
        _ = sut.view
        
        sut.display(viewModel: ErrorViewModel(message: "Não foi possível completar a operação."))
        
        let errorVC = try XCTUnwrap(sut.children.first as? ErrorViewController)
        
        XCTAssertEqual(errorVC.errorMessage, "Não foi possível completar a operação.")
        
        errorVC.retryButton.simulate(event: .touchUpInside)
        
        XCTAssertNil(errorVC.parent)
    }
    
    func testAnalyzeViewMethods() throws {
        let sut = makeSUT()
        
        sut.display(viewModel: .init(emotion: "👾"))
        
        let resultVC = try XCTUnwrap(sut.children.first as? AnalyzeResultViewController)
        
        XCTAssertEqual(resultVC.result, "👾")
    }
    
    private func makeSUT(
        onLoad: @escaping AnalyzeViewController.OnLoad = {},
        onClose: @escaping AnalyzeViewController.OnClose = { _ in }
    ) -> AnalyzeViewController {
        let sut = AnalyzeViewController()
        sut.onLoad = onLoad
        sut.onClose = onClose
        trackForMemoryLeaks(sut)
        return sut
    }
}

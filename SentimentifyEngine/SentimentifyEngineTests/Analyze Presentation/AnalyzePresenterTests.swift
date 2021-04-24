//
//  AnalyzePresenterTests.swift
//  SentimentifyEngineTests
//
//  Created by Thales Frigo on 23/04/21.
//

import XCTest
import SentimentifyTestExtensions
@testable import SentimentifyEngine

final class AnalyzePresenterTests: XCTestCase {
    
    func testPresenterInitDontEmitAnyMessages() {
        let (_, view) = makeSUT()
        XCTAssertEqual(view.messages, [])
    }

    func testPresenterTriggerLoadingAndRemoveError() {
        let (sut, view) = makeSUT()
        
        sut.didStartAnalyzing()
        
        XCTAssertEqual(
            view.messages,
            [.loading(.init(isLoading: true)), .error(.init(message: nil))]
        )
    }
    
    func testPresenterRemoveLoadingAndPresentError() {
        let (sut, view) = makeSUT()
        
        sut.didFinishAnalyze(with: NSError(domain: "offline", code: -222))
        
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
        
        sut.didFinishAnalyze(with: happyAnalyzeResult())
        
        XCTAssertEqual(
            view.messages,
            [
                .loading(.init(isLoading: false)),
                .analyze(.init(emotion: "🤩"))
            ]
        )
    }
    
    private func makeSUT() -> (sut: AnalyzePresenter, view: AnalyzeViewSpy) {
        let view = AnalyzeViewSpy()
        let sut = AnalyzePresenter(loadingView: view, errorView: view, analyzeView: view)
        trackForMemoryLeaks(view)
        trackForMemoryLeaks(sut)
        return (sut, view)
    }
}

private final class AnalyzeViewSpy: AnalyzeView, LoadingView, ErrorView {
    
    private(set) var messages = [AnalyzePresenterMessage]()
    
    func display(viewModel: LoadingViewModel) {
        messages.append(.loading(viewModel))
    }
    
    func display(viewModel: ErrorViewModel) {
        messages.append(.error(viewModel))
    }
    
    func display(viewModel: AnalyzeViewModel) {
        messages.append(.analyze(viewModel))
    }
}

private enum AnalyzePresenterMessage: Equatable {
    case loading(LoadingViewModel)
    case error(ErrorViewModel)
    case analyze(AnalyzeViewModel)
    
    static func == (lhs: AnalyzePresenterMessage, rhs: AnalyzePresenterMessage) -> Bool {
        switch (lhs, rhs) {
        case (let .loading(lhsViewModel), let .loading(rhsViewModel)):
            return lhsViewModel == rhsViewModel
        case (let .error(lhsViewModel), let .error(rhsViewModel)):
            return lhsViewModel == rhsViewModel
        case (let .analyze(lhsViewModel), let .analyze(rhsViewModel)):
            return lhsViewModel == rhsViewModel
        default:
            return false
        }
    }
}


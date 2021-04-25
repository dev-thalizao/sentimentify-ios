//
//  ErrorViewControllerTests.swift
//  SentimentifyiOSTests
//
//  Created by Thales Frigo on 25/04/21.
//

import XCTest
import SentimentifyTestExtensions
@testable import SentimentifyiOS

final class ErrorViewControllerTests: XCTestCase {
    
    func testViewControllerOnRetry() {
        var calls = 0
        let sut = makeSUT(onRetry: { _ in
            calls += 1
        })
        
        sut.retryButton.simulate(event: .touchUpInside)
        
        XCTAssertEqual(calls, 1)
    }
    
    private func makeSUT(onRetry: @escaping ErrorViewController.OnRetry = { _ in }) -> ErrorViewController {
        let sut = ErrorViewController()
        sut.onRetry = onRetry
        trackForMemoryLeaks(sut)
        return sut
    }
}

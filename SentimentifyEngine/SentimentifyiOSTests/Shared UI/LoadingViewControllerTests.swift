//
//  LoadingViewControllerTests.swift
//  SentimentifyiOSTests
//
//  Created by Thales Frigo on 25/04/21.
//

import XCTest
import SentimentifyTestExtensions
@testable import SentimentifyiOS

final class LoadingViewControllerTests: XCTestCase {
    
    func testViewControllerOnHide() {
        var calls = 0
        let sut = makeSUT(onHide: { _ in
            calls += 1
        })
        
        sut.isLoading = false
        
        XCTAssertEqual(calls, 1)
    }
    
    private func makeSUT(onHide: @escaping LoadingViewController.OnHide = { _ in }) -> LoadingViewController {
        let sut = LoadingViewController()
        sut.onHide = onHide
        trackForMemoryLeaks(sut)
        return sut
    }
}

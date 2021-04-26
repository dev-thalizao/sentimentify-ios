//
//  SearchUIComposerTests.swift
//  SentimentifyAppTests
//
//  Created by Thales Frigo on 25/04/21.
//

import XCTest
import SentimentifyEngine
import SentimentifyTestExtensions
import SentimentifyiOS
@testable import SentimentifyApp

final class SearchUIComposerTests: XCTestCase {

    func testSearchCompositionIsFreeOfLeaks() {
        let stub = SearchLoaderStub { _ in .success([]) }
        let sut = SearchUIComposer.searchComposedWith(loader: stub)
        trackForMemoryLeaks(sut)
        
        XCTAssertTrue(sut is SearchViewController)
    }
}

private final class SearchLoaderStub: SearchLoader {

    private let stub: (SearchInput) -> SearchLoader.Result
    
    init(stub: @escaping (SearchInput) -> SearchLoader.Result) {
        self.stub = stub
    }
    
    func search(using input: SearchInput, completion: @escaping (SearchLoader.Result) -> Void) {
        completion(stub(input))
    }
}

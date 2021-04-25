//
//  TwitterSearchLoaderTests.swift
//  TwitterSearchInfrastructureTests
//
//  Created by Thales Frigo on 24/04/21.
//

import XCTest

import XCTest
import SentimentifyEngine
import SentimentifyTestExtensions
@testable import TwitterSearchInfrastructure

final class TwitterSearchLoaderTests: XCTestCase {

    func testAnalyzeLoadWithSuccess() throws {
        let client = HTTPClientStub { _ in .success((makeTwitterSearchResponse(), .OK))}
        let sut = makeSUT(client: client)
        var receivedResult: SearchLoader.Result?
        let expectedResult = SearchLoader.Result { try TwitterSearchResponse.map(makeTwitterSearchResponse()) }

        sut.search(using: .init(term: "thalesfrigo")) { receivedResult = $0 }

        assertResult(receivedResult: try XCTUnwrap(receivedResult), expectedResult: expectedResult)
    }
    
    func testAnalyzeLoadWithFailure() throws {
        let client = HTTPClientStub { _ in .failure(anyError())}
        let sut = makeSUT(client: client)
        var receivedResult: SearchLoader.Result?
        let expectedResult = SearchLoader.Result.failure(anyError())

        sut.search(using: .init(term: "thalesfrigo")) { receivedResult = $0 }

        assertResult(receivedResult: try XCTUnwrap(receivedResult), expectedResult: expectedResult)
    }
    
    private func makeSUT(client: HTTPClientStub) -> TwitterSearchLoader {
        let sut = TwitterSearchLoader(client: client)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return sut
    }
}

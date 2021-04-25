//
//  NaturalLanguageAnalyzeLoaderTests.swift
//  GoogleAnalyzeInfrastructureTests
//
//  Created by Thales Frigo on 24/04/21.
//

import XCTest
import SentimentifyEngine
import SentimentifyTestExtensions
@testable import GoogleAnalyzeInfrastructure

final class NaturalLanguageAnalyzeLoaderTests: XCTestCase {

    func testAnalyzeLoadWithSuccess() throws {
        let client = HTTPClientStub { _ in .success((makeJsonResponse(score: 0.5), .OK))}
        let sut = makeSUT(client: client)
        var receivedResult: AnalyzeLoader.Result?
        let expectedResult = AnalyzeLoader.Result { .init(score: 0.5) }

        sut.analyze(using: .init(content: "Any happy content")) { receivedResult = $0 }

        assertResult(receivedResult: try XCTUnwrap(receivedResult), expectedResult: expectedResult)
    }
    
    func testAnalyzeLoadWithFailure() throws {
        let client = HTTPClientStub { _ in .failure(anyError())}
        let sut = makeSUT(client: client)
        var receivedResult: AnalyzeLoader.Result?
        let expectedResult = AnalyzeLoader.Result.failure(anyError())

        sut.analyze(using: .init(content: "Any happy content")) { receivedResult = $0 }

        assertResult(receivedResult: try XCTUnwrap(receivedResult), expectedResult: expectedResult)
    }
    
    private func makeSUT(client: HTTPClientStub) -> NaturalLanguageAnalyzeLoader {
        let sut = NaturalLanguageAnalyzeLoader(client: client)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return sut
    }
}

private func makeJsonResponse(score: Double) -> Data {
    let json: [String: Any] = [
        "documentSentiment": [
            "score": score
        ]
    ]
    return try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
}

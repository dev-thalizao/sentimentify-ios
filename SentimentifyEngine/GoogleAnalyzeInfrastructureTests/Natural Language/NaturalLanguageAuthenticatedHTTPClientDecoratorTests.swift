//
//  NaturalLanguageHTTPClientDecoratorTests.swift
//  GoogleAnalyzeInfrastructureTests
//
//  Created by Thales Frigo on 24/04/21.
//

import XCTest
import SentimentifyTestExtensions
import SentimentifyEngine
@testable import GoogleAnalyzeInfrastructure

final class NaturalLanguageAuthenticatedHTTPClientDecoratorTests: XCTestCase {
    
    func testDecoratorAddApiKeyToRequest() {
        let (sut, spy) = makeSUT()
        
        let unauthorizedRequest = NaturalLanguageAPI
            .analyzeSentiment(input: anyAnalyzeInput())
            .request()
        
        sut.execute(unauthorizedRequest) { _ in }
        
        XCTAssertEqual(spy.requests.first?.url?.query, "key=API_KEY")
    }
    
    private func makeSUT() -> (sut: NaturalLanguageAuthenticatedHTTPClientDecorator, spy: HTTPClientSpy) {
        let spy = HTTPClientSpy()
        let sut = NaturalLanguageAuthenticatedHTTPClientDecorator(
            decoratee: spy,
            credential: .init(apiKey: "API_KEY")
        )
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(spy)
        return (sut, spy)
    }
}

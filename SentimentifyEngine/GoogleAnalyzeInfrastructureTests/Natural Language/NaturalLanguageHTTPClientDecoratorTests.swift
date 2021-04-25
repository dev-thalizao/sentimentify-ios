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

final class NaturalLanguageHTTPClientDecoratorTests: XCTestCase {
    
    func testDecoratorAddApiKeyToRequest() {
        let spy = HTTPClientSpy()
        let sut = NaturalLanguageHTTPClientDecorator(
            decoratee: spy,
            credential: .init(apiKey: "API_KEY")
        )
        let unauthorizedRequest = NaturalLanguageAPI
            .analyzeSentiment(input: anyAnalyzeInput())
            .request()
        
        sut.execute(unauthorizedRequest) { _ in }
        
        XCTAssertEqual(spy.urls.first?.query, "key=API_KEY")
    }
}

private final class HTTPClientSpy: HTTPClient {
    
    private struct SpyTask: HTTPClientTask {
        func cancel() {}
    }
    
    private(set) var urls = [URL]()
    func execute(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        urls.append(request.url!)
        return SpyTask()
    }
}

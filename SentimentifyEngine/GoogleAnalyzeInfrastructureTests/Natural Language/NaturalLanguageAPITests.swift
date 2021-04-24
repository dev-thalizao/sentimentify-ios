//
//  NaturalLanguageEndpointTests.swift
//  GoogleAnalyzeInfrastructureTests
//
//  Created by Thales Frigo on 24/04/21.
//

import XCTest
@testable import GoogleAnalyzeInfrastructure

final class NaturalLanguageAPITests: XCTestCase {

    func testEndpointIsAPost() {
        XCTAssertEqual(makeSUT().httpMethod, "POST")
    }
    
    func testEndpointHasApiKey() {
        XCTAssertEqual(makeSUT().url?.query, "key=API_KEY")
    }
    
    func testEndpointURL() {
        XCTAssertEqual(
            makeSUT().url,
            URL(string: "https://language.googleapis.com/v1/documents:analyzeSentiment?key=API_KEY")
        )
    }
    
    func testEndpointJsonHeaders() {
        let contentType = makeSUT().allHTTPHeaderFields?.first(where: { $0.key == "Content-Type" })
        let accept = makeSUT().allHTTPHeaderFields?.first(where: { $0.key == "Accept" })
        
        XCTAssertEqual(contentType?.value, "application/json")
        XCTAssertEqual(accept?.value, "application/json")
    }
    
    func testEndpointHasValidJsonBody() throws {
        let request = try JSONDecoder().decode(AnalyzeSentimentRequest.self, from: makeSUT().httpBody!)
        
        XCTAssertEqual(
            request,
            AnalyzeSentimentRequest.basic("Any happy content")
        )
    }
    
    private func makeSUT() -> URLRequest {
        return NaturalLanguageAPI
            .analyzeSentiment(input: .init(content: "Any happy content"))
            .request(apiKey: "API_KEY")
    }
}



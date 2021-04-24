//
//  AnalyzeSentimentMapperTests.swift
//  GoogleAnalyzeInfrastructureTests
//
//  Created by Thales Frigo on 24/04/21.
//

import XCTest
import SentimentifyTestExtensions
@testable import GoogleAnalyzeInfrastructure

final class AnalyzeSentimentResponseTests: XCTestCase {

    func testMapperReturnScore() throws {
        let json = try makeJSONResponse(score: 1.0)
        let result = try AnalyzeSentimentResponse.map(json)
        
        XCTAssertEqual(result.value, 1.0)
    }
    
    func testMapperThrowsWithInvalidData() {
        let invalidJson = "invalid json".data(using: .utf8)!
        
        XCTAssertThrowsError(
            try AnalyzeSentimentResponse.map(invalidJson)
        )
    }
    
    private func makeJSONResponse(score: Double) throws -> Data {
        let json: [String: Any] = [
            "documentSentiment": [
                "score": score
            ]
        ]
        
        return try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    }
}

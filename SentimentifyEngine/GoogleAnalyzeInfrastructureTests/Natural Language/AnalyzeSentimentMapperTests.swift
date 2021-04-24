//
//  AnalyzeSentimentMapperTests.swift
//  GoogleAnalyzeInfrastructureTests
//
//  Created by Thales Frigo on 24/04/21.
//

import XCTest
import SentimentifyTestExtensions
@testable import GoogleAnalyzeInfrastructure

final class AnalyzeSentimentMapperTests: XCTestCase {

    func testMapperReturnScore() throws {
        let json = try makeJSONResponse(score: 1.0)
        let result = try AnalyzeSentimentMapper.map(json, response: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result.value, 1.0)
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

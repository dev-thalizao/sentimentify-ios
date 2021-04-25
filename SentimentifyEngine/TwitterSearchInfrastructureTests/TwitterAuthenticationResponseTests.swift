//
//  TwitterAuthenticationResponseTests.swift
//  TwitterSearchInfrastructureTests
//
//  Created by Thales Frigo on 24/04/21.
//

import XCTest
@testable import TwitterSearchInfrastructure

final class TwitterAuthenticationResponseTests: XCTestCase {

    func testMapperReturnValue() throws {
        let json = try makeJSONResponse()
        let result = try TwitterAuthenticationResponse.map(json)
        
        XCTAssertEqual(result.value, "X")
    }
    
    func testMapperThrowsWithInvalidData() {
        let invalidJson = "invalid json".data(using: .utf8)!
        
        XCTAssertThrowsError(
            try TwitterAuthenticationResponse.map(invalidJson)
        )
    }
    
    private func makeJSONResponse() throws -> Data {
        let json: [String: Any] = [
            "access_token": "X"
        ]
        
        return try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    }
}

//
//  AnalyzeSentimentRequestTests.swift
//  GoogleAnalyzeInfrastructureTests
//
//  Created by Thales Frigo on 24/04/21.
//

import XCTest
@testable import GoogleAnalyzeInfrastructure

final class AnalyzeSentimentRequestTests: XCTestCase {

    func testMapReturnAValidJson() throws {
        let data = try AnalyzeSentimentRequest.map(input: .init(content: "Any sad content"))
        let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        
        let encoding = dictionary["encodingType"] as! String
        let document = dictionary["document"] as! [String: Any]
        let content = document["content"] as! String
        let type = document["type"] as! String
        
        XCTAssertEqual(content, "Any sad content")
        XCTAssertEqual(type, "PLAIN_TEXT")
        XCTAssertEqual(encoding, "UTF8")
    }
}

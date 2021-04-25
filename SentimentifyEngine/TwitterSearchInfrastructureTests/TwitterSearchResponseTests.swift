//
//  TwitterSearchResponseTests.swift
//  TwitterSearchInfrastructureTests
//
//  Created by Thales Frigo on 24/04/21.
//

import XCTest
import SentimentifyEngine
import SentimentifyTestExtensions
@testable import TwitterSearchInfrastructure

final class TwitterSearchResponseTests: XCTestCase {

    func testMapperReturnValue() throws {
        let result = try TwitterSearchResponse.map(makeTwitterSearchResponse())
        
        let expected = SearchResult(
            content: .init(
                id: "1071107120219783168",
                text: "I just skipped 19 minutes of simple-minded donkey work by generating 164 lines of #swift with @quicktypeio 🎉😎 https://t.co/hJL5EpUVqG",
                createdAt: makeCreatedAtDate()
            ),
            author: .init(
                name: "Thales Frigo",
                username: "thalesfrigo",
                photo: URL(string: "http://pbs.twimg.com/profile_images/602296681070239744/7v7JRjlI_normal.jpg")
            )
        )
        
        XCTAssertEqual(result.first, expected)
    }
    
    func testMapperThrowsWithInvalidData() {
        let invalidJson = "invalid json".data(using: .utf8)!
        
        XCTAssertThrowsError(
            try TwitterAuthenticationResponse.map(invalidJson)
        )
    }
    
    private func makeCreatedAtDate() -> Date {
        return DateFormatter.twitterDateFormat.date(from: "Fri Dec 07 18:20:12 +0000 2018")!
    }
}

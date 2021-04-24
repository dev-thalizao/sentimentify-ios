//
//  XCTest+Result.swift
//  SentimentifyTestExtensions
//
//  Created by Thales Frigo on 24/04/21.
//

import XCTest

public extension XCTestCase {
    
    func assertResult<S, F>(
        receivedResult: Swift.Result<S, F>,
        expectedResult: Swift.Result<S, F>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) where S: Equatable, F: Swift.Error {
        switch (receivedResult, expectedResult) {
        case let (.success(receivedItems), .success(expectedItems)):
            XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            
        case let (.failure(receivedError), .failure(expectedError)):
            XCTAssertTrue(receivedError.isEqual(other: expectedError), file: file, line: line)

        default:
            XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
        }
    }
}

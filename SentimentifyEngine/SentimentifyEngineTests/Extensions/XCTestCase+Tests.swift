//
//  Result+Tests.swift
//  SentimentifyEngineTests
//
//  Created by Thales Frigo on 21/04/21.
//

import XCTest

// MARK: - Result Methods

public extension XCTestCase {
    
    func assertResult<S, F>(
        receivedResult: Result<S, Error>,
        expectedResult: Result<S, F>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) where S: Equatable, F: Equatable, F: Error {
        switch (receivedResult, expectedResult) {
        case let (.success(receivedItems), .success(expectedItems)):
            XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            
        case let (.failure(receivedError as F), .failure(expectedError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)

        default:
            XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
        }
    }
}

// MARK: - Memory Leaks Methods

public extension XCTestCase {
    
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}


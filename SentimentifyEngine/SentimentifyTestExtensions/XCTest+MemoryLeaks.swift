//
//  XCTest+MemoryLeaks.swift
//  SentimentifyTestExtensions
//
//  Created by Thales Frigo on 24/04/21.
//

import XCTest

public extension XCTestCase {
    
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}

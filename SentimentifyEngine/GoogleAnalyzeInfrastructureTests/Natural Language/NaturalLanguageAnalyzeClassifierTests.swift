//
//  NaturalLanguageAnalyzeClassifierTests.swift
//  GoogleAnalyzeInfrastructureTests
//
//  Created by Thales Frigo on 24/04/21.
//

import XCTest
import SentimentifyEngine
@testable import GoogleAnalyzeInfrastructure

final class NaturalLanguageAnalyzeClassifierTests: XCTestCase {

    func testClassificationOfHappyResult() {
        XCTAssertEqual(makeSUT(score: 0.6), "🤩")
    }
    
    func testClassificationOfNeutralResult() {
        XCTAssertEqual(makeSUT(score: 0.1), "😐")
    }
    
    func testClassificationOfSadResult() {
        XCTAssertEqual(makeSUT(score: -0.3), "😞")
    }
    
    private func makeSUT(score: Double) -> String {
        let sut = NaturalLanguageAnalyzeClassifier()
        let result = sut.classify(score: .init(score: score))
        return result.emotion
    }
}

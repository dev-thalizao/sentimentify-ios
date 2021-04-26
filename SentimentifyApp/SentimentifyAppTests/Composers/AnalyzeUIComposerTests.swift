//
//  AnalyzeUIComposerTests.swift
//  SentimentifyAppTests
//
//  Created by Thales Frigo on 25/04/21.
//

import XCTest
import SentimentifyEngine
import SentimentifyTestExtensions
import SentimentifyiOS
@testable import SentimentifyApp

final class AnalyzeUIComposerTests: XCTestCase {

    func testSearchCompositionIsFreeOfLeaks() {
        let sut = AnalyzeUIComposer.analyzeComposedWith(
            content: "any content",
            loader: AnalyzeLoaderStub { _ in .failure(anyError()) },
            classifier: AnalyzeClassifierFake()
        )
        trackForMemoryLeaks(sut)
        
        XCTAssertTrue(sut is AnalyzeViewController)
    }
}

private final class AnalyzeLoaderStub: AnalyzeLoader {

    private let stub: (AnalyzeInput) -> AnalyzeLoader.Result
    
    init(stub: @escaping (AnalyzeInput) -> AnalyzeLoader.Result) {
        self.stub = stub
    }
    
    func analyze(using term: AnalyzeInput, completion: @escaping (AnalyzeLoader.Result) -> Void) {
        completion(stub(term))
    }
}

private final class AnalyzeClassifierFake: AnalyzeClassifier {
    
    func classify(score: AnalyzeScore) -> AnalyzeResult {
        switch score.value {
        case _ where score.value < -0.2:
            return sadAnalyzeResult()
        case _ where score.value < 0.5:
            return neutralAnalyzeResult()
        default:
            return happyAnalyzeResult()
        }
    }
}

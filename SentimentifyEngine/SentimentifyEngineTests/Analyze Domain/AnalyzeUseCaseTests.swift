//
//  AnalyzeUseCaseTests.swift
//  SentimentifyEngineTests
//
//  Created by Thales Frigo on 23/04/21.
//

import XCTest
@testable import SentimentifyEngine

final class AnalyzeUseCaseTests: XCTestCase {
    
    func testUseCaseInitDontEmitAnyMessages() {
        let (_, output) = makeSUT()
        XCTAssertEqual(output.messages, [])
    }

    func testUseCaseShouldCompleteWithHappyScore() {
        let (sut, output) = makeSUT { _ in .success(happyAnalyzeScore()) }
        
        sut.analyze(using: .init(content: "any happy content"))
        
        XCTAssertEqual(output.messages, [.loading, .finished(happyAnalyzeResult())])
    }
    
    func testUseCaseShouldCompleteWithNeutralScore() {
        let (sut, output) = makeSUT { _ in .success(neutralAnalyzeScore()) }
        
        sut.analyze(using: .init(content: "any happy content"))
        
        XCTAssertEqual(output.messages, [.loading, .finished(neutralAnalyzeResult())])
    }
    
    func testUseCaseShouldCompleteWithSadScore() {
        let (sut, output) = makeSUT { _ in .success(sadAnalyzeScore()) }
        
        sut.analyze(using: .init(content: "any happy content"))
        
        XCTAssertEqual(output.messages, [.loading, .finished(sadAnalyzeResult())])
    }
    
    func testUseCaseShouldCompleteWithFailure() {
        let (sut, output) = makeSUT { _ in .failure(anyError()) }
        
        sut.analyze(using: .init(content: "any content"))
        
        XCTAssertEqual(output.messages, [.loading, .failed(anyError())])
    }
    
    private func makeSUT(
        stub: @escaping (AnalyzeInput) -> AnalyzeLoader.Result = { _ in .success(neutralAnalyzeScore()) }
    ) -> (sut: AnalyzeUseCase, output: AnalyzeUseCaseOutputSpy) {
        let output = AnalyzeUseCaseOutputSpy()
        let loader = AnalyzeLoaderStub(stub: stub)
        let classifier = AnalyzeClassifierFake()
        let sut = AnalyzeUseCase(output: output, loader: loader, classifier: classifier)
        
        trackForMemoryLeaks(output)
        trackForMemoryLeaks(loader)
        trackForMemoryLeaks(classifier)
        trackForMemoryLeaks(sut)
        
        return (sut, output)
    }
}

private final class AnalyzeUseCaseOutputSpy: AnalyzeUseCaseOutput {
    private(set) var messages = [AnalyzeUseCaseOutputMessage]()
    
    func didStartAnalyzing() {
        messages.append(.loading)
    }
    
    func didFinishAnalyze(with result: AnalyzeResult) {
        messages.append(.finished(result))
    }
    
    func didFinishAnalyze(with error: Error) {
        messages.append(.failed(error))
    }
}

private enum AnalyzeUseCaseOutputMessage: Equatable {
    case loading
    case finished(AnalyzeResult)
    case failed(Error)
    
    static func == (lhs: AnalyzeUseCaseOutputMessage, rhs: AnalyzeUseCaseOutputMessage) -> Bool {
        switch (lhs, rhs) {
        case (let .finished(lhsResult), let .finished(rhsResult)):
            return lhsResult == rhsResult
        case (let .failed(lhsError), let .failed(rhsError)):
            return lhsError.isEqual(other: rhsError)
        case (.loading, .loading):
            return true
        default:
            return false
        }
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

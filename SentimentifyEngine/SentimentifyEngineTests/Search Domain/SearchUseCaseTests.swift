//
//  SearchUseCaseTests.swift
//  SentimentifyEngineTests
//
//  Created by Thales Frigo on 23/04/21.
//

import XCTest
@testable import SentimentifyEngine

final class SearchUseCaseTests: XCTestCase {
    
    func testUseCaseInitDontEmitMessage() {
        let (_, output) = makeSUT { _ in .success(anySearchResults()) }
        XCTAssertEqual(output.messages, [])
    }

    func testUseCaseShouldCompleteWithSuccess() {
        let (sut, output) = makeSUT { _ in .success(anySearchResults()) }
        
        sut.search(using: .init(term: "thalizao"))
        
        XCTAssertEqual(output.messages, [.loading, .finished(anySearchResults())])
    }
    
    func testUseCaseShouldCompleteWithFailure() {
        let (sut, output) = makeSUT { _ in .failure(anyError()) }
        
        sut.search(using: .init(term: "thalizao"))
        
        XCTAssertEqual(output.messages, [.loading, .failed(anyError())])
    }
    
    func testUseCaseShouldFailedAtFirstThenShouldCompleteWithSuccess() {
        let (sut, output) = makeSUT { input in
            input.term == "thalizao"
                ? .success(anySearchResults())
                : .failure(anyError())
        }
        
        sut.search(using: .init(term: "thalisao"))
        
        XCTAssertEqual(output.messages, [.loading, .failed(anyError())])
        
        sut.search(using: .init(term: "thalizao"))
        
        XCTAssertEqual(
            output.messages,
            [.loading, .failed(anyError()), .loading, .finished(anySearchResults())]
        )
    }
    
    private func makeSUT(
        stub: @escaping (SearchTerm) -> SearchLoader.Result
    ) -> (sut: SearchUseCase, output: SearchUseCaseOutputSpy) {
        let output = SearchUseCaseOutputSpy()
        let loader = SearchLoaderStub(stub: stub)
        let sut = SearchUseCase(output: output, loader: loader)
        
        trackForMemoryLeaks(output)
        trackForMemoryLeaks(loader)
        trackForMemoryLeaks(sut)
        
        return (sut, output)
    }
}

private final class SearchUseCaseOutputSpy: SearchUseCaseOutput {
    
    private(set) var messages = [SearchUseCaseOutputMessage]()
    
    func didStartSearching() {
        messages.append(.loading)
    }
    
    func didFinishSearch(with results: [SearchResult]) {
        messages.append(.finished(results))
    }
    
    func didFinishSearch(with error: Error) {
        messages.append(.failed(error))
    }
}

private enum SearchUseCaseOutputMessage: Equatable {
    case loading
    case finished([SearchResult])
    case failed(Error)
    
    static func == (lhs: SearchUseCaseOutputMessage, rhs: SearchUseCaseOutputMessage) -> Bool {
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

private final class SearchLoaderStub: SearchLoader {

    private let stub: (SearchTerm) -> SearchLoader.Result
    
    init(stub: @escaping (SearchTerm) -> SearchLoader.Result) {
        self.stub = stub
    }
    
    func search(using term: SearchTerm, completion: @escaping (SearchLoader.Result) -> Void) {
        completion(stub(term))
    }
}

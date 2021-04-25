//
//  SearchUseCaseTests.swift
//  SentimentifyEngineTests
//
//  Created by Thales Frigo on 23/04/21.
//

import XCTest
import SentimentifyTestExtensions
@testable import SentimentifyEngine

final class SearchUseCaseTests: XCTestCase {
    
    func testUseCaseInitDontEmitAnyMessages() {
        let (_, output) = makeSUT { _ in .success(anySearchResultArray()) }
        XCTAssertEqual(output.messages, [])
    }

    func testUseCaseShouldCompleteWithSuccess() {
        let (sut, output) = makeSUT { _ in .success(anySearchResultArray()) }
        
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
                ? .success(anySearchResultArray())
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
    
    func testUseCaseShouldCompleteWithSuccessAndNextPage() {
        var isFirstTime: Bool = true
        
        let (sut, output) = makeSUT { _ in
            if isFirstTime {
                isFirstTime.toggle()
                return .success(anySearchResultArray(3))
            } else {
                return .success(anySearchResultArray(0))
            }
        }

        sut.search(using: .init(term: "thalizao"))

        XCTAssertEqual(output.messages, [.loading, .finished(anySearchResults(3))])

        if case let .finished(searchResults) = output.messages.last {
            XCTAssertNotNil(searchResults.nextResults)
            searchResults.nextResults?()
        } else {
            XCTFail("The last message should be a search result with next page")
        }

        XCTAssertEqual(
            output.messages,
            [.loading, .finished(anySearchResults(3)), .loading, .finished(anySearchResults(0))]
        )
        
        if case let .finished(searchResults) = output.messages.last {
            XCTAssertNil(searchResults.nextResults)
        } else {
            XCTFail("The last message should be a search result without next page")
        }
    }
    
    private func makeSUT(
        stub: @escaping (SearchInput) -> SearchLoader.Result
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
    
    func didFinishSearch(with results: SearchResults) {
        messages.append(.finished(results))
    }
    
    func didFinishSearch(with error: Error) {
        messages.append(.failed(error))
    }
}

private enum SearchUseCaseOutputMessage: Equatable {
    case loading
    case finished(SearchResults)
    case failed(Error)
    
    static func == (lhs: SearchUseCaseOutputMessage, rhs: SearchUseCaseOutputMessage) -> Bool {
        switch (lhs, rhs) {
        case (let .finished(lhsResult), let .finished(rhsResult)):
            return lhsResult.results == rhsResult.results
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

    private let stub: (SearchInput) -> SearchLoader.Result
    
    init(stub: @escaping (SearchInput) -> SearchLoader.Result) {
        self.stub = stub
    }
    
    func search(using input: SearchInput, completion: @escaping (SearchLoader.Result) -> Void) {
        completion(stub(input))
    }
}

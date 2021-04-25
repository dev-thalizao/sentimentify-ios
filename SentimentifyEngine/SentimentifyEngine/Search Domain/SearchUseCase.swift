//
//  SearchUseCase.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 23/04/21.
//

import Foundation

public protocol SearchUseCaseOutput {
    func didStartSearching()
    func didFinishSearch(with results: SearchResults)
    func didFinishSearch(with error: Error)
}

public final class SearchUseCase {
    
    private let output: SearchUseCaseOutput
    private let loader: SearchLoader
    
    public init(output: SearchUseCaseOutput, loader: SearchLoader) {
        self.output = output
        self.loader = loader
    }
    
    public func search(using input: SearchInput) {
        output.didStartSearching()
        
        loader.search(using: input) { [weak self] (result) in
            switch result {
            case let .success(results):
                let nextInput = SearchInput(term: input.term, after: results.last?.content.id)
                let nextResults: NextResultsCompletion? = !results.isEmpty
                    ? { self?.search(using: nextInput) }
                    : nil
                
                let searchResults = SearchResults(
                    results: results,
                    nextResults: nextResults
                )
                
                self?.output.didFinishSearch(with: searchResults)
            case let .failure(error):
                self?.output.didFinishSearch(with: error)
            }
        }
    }
}

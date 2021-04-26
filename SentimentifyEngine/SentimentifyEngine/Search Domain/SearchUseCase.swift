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
    
    public func search(using input: SearchInput) -> Void {
        guard isValidInput(input) else { return }
        
        output.didStartSearching()
        
        loader.search(using: input) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case let .success(results):
                // TODO: - Move pagination compose to the loader
                if results.count < 10 {
                    self.output.didFinishSearch(with: .init(results: results, nextResults: nil))
                } else {
                    let nextInput = SearchInput(term: input.term, after: results.last?.content.id)
                    let searchResults = SearchResults(
                        results: results,
                        nextResults: { [weak self] in self?.search(using: nextInput) }
                    )
                    
                    self.output.didFinishSearch(with: searchResults)
                }
            case let .failure(error):
                self.output.didFinishSearch(with: error)
            }
        }
    }
    
    private func isValidInput(_ input: SearchInput) -> Bool {
        return !input.term.isEmpty
    }
}

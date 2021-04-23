//
//  SearchUseCase.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 23/04/21.
//

import Foundation

public protocol SearchUseCaseOutput {
    func didStartSearching()
    func didFinishSearch(with results: [SearchResult])
    func didFinishSearch(with error: Error)
}

public final class SearchUseCase {
    
    private let output: SearchUseCaseOutput
    private let loader: SearchLoader
    
    public init(output: SearchUseCaseOutput, loader: SearchLoader) {
        self.output = output
        self.loader = loader
    }
    
    public func search(using term: SearchTerm) {
        output.didStartSearching()
        
        loader.search(using: term) { [output] (result) in
            switch result {
            case let .success(results):
                output.didFinishSearch(with: results)
            case let .failure(error):
                output.didFinishSearch(with: error)
            }
        }
    }
}

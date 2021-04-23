//
//  AnalyzeUseCase.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 23/04/21.
//

import Foundation

public protocol AnalyzeUseCaseOutput {
    func didStartAnalyzing()
    func didFinishAnalyze(with result: AnalyzeResult)
    func didFinishAnalyze(with error: Error)
}

public final class AnalyzeUseCase {
    private let output: AnalyzeUseCaseOutput
    private let loader: AnalyzeLoader
    private let classifier: AnalyzeClassifier
    
    public init(output: AnalyzeUseCaseOutput, loader: AnalyzeLoader, classifier: AnalyzeClassifier) {
        self.output = output
        self.loader = loader
        self.classifier = classifier
    }
    
    public func analyze(using input: AnalyzeInput) {
        output.didStartAnalyzing()
        
        loader.analyze(using: input) { [output, classifier] (result) in
            switch result {
            case let .success(score):
                output.didFinishAnalyze(with: classifier.classify(score: score))
            case let .failure(error):
                output.didFinishAnalyze(with: error)
            }
        }
    }
}

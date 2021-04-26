//
//  AnalyzePresenter.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 23/04/21.
//

import Foundation

public protocol AnalyzeView {
    func display(viewModel: AnalyzeViewModel)
}

public struct AnalyzeViewModel: Equatable {
    public let emotion: String
}

public final class AnalyzePresenter: AnalyzeUseCaseOutput {

    private let loadingView: LoadingView
    private let errorView: ErrorView
    private let analyzeView: AnalyzeView
    
    public init(loadingView: LoadingView, errorView: ErrorView, analyzeView: AnalyzeView) {
        self.loadingView = loadingView
        self.errorView = errorView
        self.analyzeView = analyzeView
    }
    
    public func didStartAnalyzing() {
        loadingView.display(viewModel: .init(isLoading: true))
        errorView.display(viewModel: .init(message: nil))
    }
    
    public func didFinishAnalyze(with result: AnalyzeResult) {
        loadingView.display(viewModel: .init(isLoading: false))
        analyzeView.display(viewModel: .init(emotion: result.emotion))
    }
    
    public func didFinishAnalyze(with error: Error) {
        loadingView.display(viewModel: .init(isLoading: false))
        errorView.display(viewModel: .init(message: error.localizedDescription))
    }
}

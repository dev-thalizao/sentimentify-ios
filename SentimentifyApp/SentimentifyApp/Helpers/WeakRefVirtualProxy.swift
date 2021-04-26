//
//  WeakRefVirtualProxy.swift
//  SentimentifyApp
//
//  Created by Thales Frigo on 25/04/21.
//

import Foundation
import SentimentifyEngine

final class WeakRefVirtualProxy<T: AnyObject> {
    
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: ErrorView where T: ErrorView {
    
    func display(viewModel: ErrorViewModel) {
        object?.display(viewModel: viewModel)
    }
}

extension WeakRefVirtualProxy: LoadingView where T: LoadingView {
    
    func display(viewModel: LoadingViewModel) {
        object?.display(viewModel: viewModel)
    }
}

extension WeakRefVirtualProxy: SearchView where T: SearchView {
    
    func display(viewModel: SearchViewModel) {
        object?.display(viewModel: viewModel)
    }
}

extension WeakRefVirtualProxy: AnalyzeView where T: AnalyzeView {
    
    func display(viewModel: AnalyzeViewModel) {
        object?.display(viewModel: viewModel)
    }
}

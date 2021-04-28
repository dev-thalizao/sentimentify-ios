//
//  AnalyzeUIComposer.swift
//  SentimentifyApp
//
//  Created by Thales Frigo on 25/04/21.
//

import UIKit
import SentimentifyEngine
import SentimentifyiOS

public final class AnalyzeUIComposer {
    
    private init() {}
    
    public static func analyzeComposedWith(
        content: String,
        loader: AnalyzeLoader,
        classifier: AnalyzeClassifier,
        onClose: @escaping (UIViewController) -> Void = { _ in }
    ) -> UIViewController {
        let view = AnalyzeViewController()
        let presenter = AnalyzePresenter(
            loadingView: WeakRefVirtualProxy(view),
            errorView: HumanReadableErrorViewDecorator(decoratee: WeakRefVirtualProxy(view)),
            analyzeView: WeakRefVirtualProxy(view)
        )
        
        let useCase = AnalyzeUseCase(
            output: presenter,
            loader: MainQueueDispatchDecorator(loader),
            classifier: classifier
        )
        
        view.onLoad = { [useCase] in
            useCase.analyze(using: .init(content: content))
        }
        
        view.onClose = onClose
        
        return view
    }
}

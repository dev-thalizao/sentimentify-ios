//
//  ErrorDisplaySearchUseCaseOutput.swift
//  SentimentifyApp
//
//  Created by Thales Frigo on 26/04/21.
//

import Foundation
import SentimentifyEngine

final class HumanReadableErrorViewDecorator: ErrorView {
    
    private let decoratee: ErrorView
    
    init(decoratee: ErrorView) {
        self.decoratee = decoratee
    }
    
    func display(viewModel: ErrorViewModel) {
        #if targetEnvironment(simulator) && DEBUG
            decoratee.display(viewModel: viewModel)
        #else
            decoratee.display(viewModel: .init(message: "Não foi possível completar a operação."))
        #endif
    }
}

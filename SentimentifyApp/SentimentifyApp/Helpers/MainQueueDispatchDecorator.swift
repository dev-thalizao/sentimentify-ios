//
//  MainQueueDispatchDecorator.swift
//  SentimentifyApp
//
//  Created by Thales Frigo on 28/04/21.
//

import Foundation
import SentimentifyEngine

final class MainQueueDispatchDecorator<T> {
    
    private let decoratee: T
    
    init(_ decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(work: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: work)
        }
        
        work()
    }
}

extension MainQueueDispatchDecorator: HTTPClient where T == HTTPClient {
    
    func execute(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        decoratee.execute(request) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: SearchLoader where T == SearchLoader {
    
    func search(using input: SearchInput, completion: @escaping (SearchLoader.Result) -> Void) {
        decoratee.search(using: input) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: AnalyzeLoader where T == AnalyzeLoader {
    
    func analyze(using input: AnalyzeInput, completion: @escaping (AnalyzeLoader.Result) -> Void) {
        decoratee.analyze(using: input) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

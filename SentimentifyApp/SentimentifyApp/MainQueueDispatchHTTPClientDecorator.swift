//
//  MainQueueDispatchHTTPClientDecorator.swift
//  SentimentifyApp
//
//  Created by Thales Frigo on 25/04/21.
//

import Foundation
import SentimentifyEngine

final class MainQueueDispatchHTTPClientDecorator: HTTPClient {

    private let decoratee: HTTPClient
    
    init(decoratee: HTTPClient) {
        self.decoratee = decoratee
    }
    
    func execute(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        return decoratee.execute(request) { (result) in
            guaranteeMainThread {
                completion(result)
            }
        }
    }
}

final class MainQueueSearchUseCaseOutputDecorator: SearchUseCaseOutput {
    
    private let decoratee: SearchUseCaseOutput
    
    init(decoratee: SearchUseCaseOutput) {
        self.decoratee = decoratee
    }
    
    func didStartSearching() {
        DispatchQueue.main.async {
            self.decoratee.didStartSearching()
        }
    }
    
    func didFinishSearch(with results: SearchResults) {
        DispatchQueue.main.async {
            self.decoratee.didFinishSearch(with: results)
        }
    }
    
    func didFinishSearch(with error: Error) {
        DispatchQueue.main.async {
            self.decoratee.didFinishSearch(with: error)
        }
    }
}

private func guaranteeMainThread(_ work: @escaping () -> Void) {
    if Thread.isMainThread {
        work()
    } else {
        DispatchQueue.main.async(execute: work)
    }
}

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

private func guaranteeMainThread(_ work: @escaping () -> Void) {
    if Thread.isMainThread {
        work()
    } else {
        DispatchQueue.main.async(execute: work)
    }
}

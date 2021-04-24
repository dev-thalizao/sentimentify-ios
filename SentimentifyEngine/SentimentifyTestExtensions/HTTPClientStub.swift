//
//  HTTPClientStub.swift
//  SentimentifyEngineTests
//
//  Created by Thales Frigo on 22/04/21.
//

import Foundation
import SentimentifyEngine

final class HTTPClientStub: HTTPClient {
    
    private class Task: HTTPClientTask {
        func cancel() {}
    }
    
    private let stub: (URLRequest) -> HTTPClient.Result
    
    init(stub: @escaping (URLRequest) -> HTTPClient.Result) {
        self.stub = stub
    }
    
    func execute(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        completion(stub(request))
        return Task()
    }
}

//
//  HTTPClientStub.swift
//  SentimentifyEngineTests
//
//  Created by Thales Frigo on 22/04/21.
//

import Foundation
import SentimentifyEngine

private class FakeTask: HTTPClientTask {
    func cancel() {}
}

public final class HTTPClientStub: HTTPClient {
    
    public private(set) var requests = [URLRequest]()

    private let stub: (URLRequest) -> HTTPClient.Result
    
    public init(stub: @escaping (URLRequest) -> HTTPClient.Result) {
        self.stub = stub
    }
    
    public func execute(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        requests.append(request)
        completion(stub(request))
        return FakeTask()
    }
}

public final class HTTPClientSpy: HTTPClient {
    
    public private(set) var requests = [URLRequest]()
    
    public init() {}
    
    public func execute(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        requests.append(request)
        return FakeTask()
    }
}

//
//  HTTPClient.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 22/04/21.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func execute(_ request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask
}

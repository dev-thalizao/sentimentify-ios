//
//  NaturalLanguageHTTPClientDecorator.swift
//  GoogleAnalyzeInfrastructure
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation
import SentimentifyEngine

public final class NaturalLanguageAuthenticatedHTTPClientDecorator: HTTPClient {
    
    private let decoratee: HTTPClient
    private let credential: NaturalLanguageCredential
    
    public init(decoratee: HTTPClient, credential: NaturalLanguageCredential) {
        self.decoratee = decoratee
        self.credential = credential
    }
    
    @discardableResult
    public func execute(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        
        var components = request.url.flatMap({ URLComponents(url: $0, resolvingAgainstBaseURL: false) })

        if var queryItems = components?.queryItems {
            queryItems.append(.init(name: "key", value: credential.apiKey))
        } else {
            components?.queryItems = [.init(name: "key", value: credential.apiKey)]
        }
        
        var mutableRequest = request
        mutableRequest.url = components?.url
        
        return decoratee.execute(mutableRequest, completion: completion)
    }
}

//
//  TwitterAuthenticatedHTTPClientDecorator.swift
//  TwitterSearchInfrastructure
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation

import Foundation
import SentimentifyEngine

public final class TwitterAuthenticatedHTTPClientDecorator: HTTPClient {
    
    private let decoratee: HTTPClient
    private let credential: TwitterCredential
    private var accessToken: TwitterAccessToken?
    
    public init(decoratee: HTTPClient, credential: TwitterCredential) {
        self.decoratee = decoratee
        self.credential = credential
    }
    
    @discardableResult
    public func execute(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        if let auth = accessToken {
            return decoratee.execute(request.signed(bearer: auth.value), completion: completion)
        } else {
            let authentication = TwitterAPI.authentication(credential: credential).request()
            return decoratee.execute(authentication) { [weak self] (result) in
                switch result {
                case let .success((data, _)):
                    guard let auth = try? TwitterAuthenticationResponse.map(data) else {
                        self?.decoratee.execute(request, completion: completion)
                        return
                    }
                    
                    self?.accessToken = auth
                    
                    self?.decoratee.execute(
                        request.signed(bearer: auth.value),
                        completion: completion
                    )
                    
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}

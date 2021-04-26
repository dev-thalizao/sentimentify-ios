//
//  ValidationStatusCodeHTTPClientDecorator.swift
//  SentimentifyApp
//
//  Created by Thales Frigo on 26/04/21.
//

import Foundation
import SentimentifyEngine

final class ValidationStatusCodeHTTPClientDecorator: HTTPClient {
    
    private let decoratee: HTTPClient
    
    init(decoratee: HTTPClient) {
        self.decoratee = decoratee
    }
    
    struct ApplicationError: Error {}
    struct ServerError: Error {}
    struct UnknownError: Error {}
    
    func execute(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        decoratee.execute(request) { (result) in
            switch result {
            case let .success((data, response)):
                switch response.statusCode {
                case 200..<300:
                    completion(.success((data, response)))
                case 300..<400:
                    completion(.success((data, response)))
                case 400..<500:
                    completion(.failure(ApplicationError()))
                case 500..<600:
                    completion(.failure(ServerError()))
                default:
                    completion(.failure(UnknownError()))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

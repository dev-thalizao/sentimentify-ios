//
//  LogHTTPClientDecorator.swift
//  SentimentifyApp
//
//  Created by Thales Frigo on 25/04/21.
//

import Foundation
import SentimentifyEngine

final class LogDecorator<T> {
    
    private let decoratee: T
    
    init(_ decoratee: T) {
        self.decoratee = decoratee
    }
    
    func log(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        #if targetEnvironment(simulator) && DEBUG
            print(items, separator: separator, terminator: terminator)
        #endif
    }
}

extension LogDecorator: HTTPClient where T: HTTPClient {
    
    func execute(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        
        log("-------------- Request Started 🚀 -------------- ")
        
        if let url = request.url {
            log("Request URL: \(url)")
        }
        
        if let headers = request.allHTTPHeaderFields {
            log("Request Headers: \(headers)")
        }
        
        if let method = request.httpMethod {
            log("Request Method: \(method)")
        }
        
        if let httpBody = request.httpBody, let requestBody = String(data: httpBody, encoding: .utf8) {
            log("Request Body: \(requestBody)")
        }
        
        return decoratee.execute(request) { [weak self] result in
            switch result {
            case let .success((data, response)):
                if let url = response.url {
                    self?.log("Response URL: \(url)")
                }
                
                self?.log("Response Headers: \(response.allHeaderFields)")
                
                self?.log("Response Status Code: \(response.statusCode)")
                
                if let responseBody = String(data: data, encoding: .utf8) {
                    self?.log("Response Body: \(responseBody)")
                }
                
            case let .failure(error):
                self?.log("HTTPClient failed: \(error)")
            }
            
            self?.log("-------------- Request Completed 🚀 -------------- ")
            
            completion(result)
        }
    }
}

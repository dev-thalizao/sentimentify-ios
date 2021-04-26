//
//  LogHTTPClientDecorator.swift
//  SentimentifyApp
//
//  Created by Thales Frigo on 25/04/21.
//

import Foundation
import SentimentifyEngine

public func SALog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if targetEnvironment(simulator) && DEBUG
        print(items, separator: separator, terminator: terminator)
    #endif
}

final class LogHTTPClientDecorator: HTTPClient {

    private let decoratee: HTTPClient
    
    init(decoratee: HTTPClient) {
        self.decoratee = decoratee
    }
    
    func execute(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        SALog("-------------- Request Started 🚀 -------------- ")
        
        if let url = request.url {
            SALog("Request URL: \(url)")
        }
        
        if let headers = request.allHTTPHeaderFields {
            SALog("Request Headers: \(headers)")
        }
        
        if let method = request.httpMethod {
            SALog("Request Method: \(method)")
        }
        
        if let httpBody = request.httpBody, let requestBody = String(data: httpBody, encoding: .utf8) {
            SALog("Request Body: \(requestBody)")
        }
        
        return decoratee.execute(request) { (result) in
            switch result {
            case let .success((data, response)):
                SALog("Response Status Code: \(response.statusCode)")
                
                if let url = response.url {
                    SALog("Response URL: \(url)")
                }
                
                SALog("Response Headers: \(response.allHeaderFields)")
                
                if let responseBody = String(data: data, encoding: .utf8) {
                    SALog("Response Body: \(responseBody)")
                }
                
                
            case let .failure(error):
                SALog("HTTPClient failed: \(error)")
            }
            
            SALog("-------------- Request Completed 🚀 -------------- ")
            
            completion(result)
        }
    }
}

//
//  TwitterAPI.swift
//  TwitterSearchInfrastructure
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation
import SentimentifyEngine

enum TwitterAPI {
    
    static let baseURL = URL(string: "https://api.twitter.com")!
    
    case authentication(credential: TwitterCredential)
    case userTimeline(input: SearchInput)
    
    func request() -> URLRequest {
        switch self {
        case let .authentication(credential):
            var components = URLComponents()
            components.scheme = Self.baseURL.scheme
            components.host = Self.baseURL.host
            components.path = Self.baseURL.path + "/oauth2/token"
            components.queryItems = [
                .init(name: "grant_type", value: "client_credentials")
            ]
            
            var request = URLRequest(url: components.url!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            credential.encoded().flatMap { (authorization) in
                request.addValue("Basic \(authorization)", forHTTPHeaderField: "Authorization")
            }
            return request
        case let .userTimeline(input):
            var components = URLComponents()
            components.scheme = Self.baseURL.scheme
            components.host = Self.baseURL.host
            components.path = Self.baseURL.path + "/1.1/statuses/user_timeline.json"
            components.queryItems = [
                URLQueryItem(name: "screen_name", value: input.term),
                URLQueryItem(name: "count", value: "10"),
                input.after.map({ URLQueryItem(name: "max_id", value: $0) })
            ].compactMap { $0 }

            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            return request
        }
    }
}

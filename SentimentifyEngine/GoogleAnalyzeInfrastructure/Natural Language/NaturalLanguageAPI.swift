//
//  NaturalLanguageAPI.swift
//  GoogleAnalyzeInfrastructure
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation
import SentimentifyEngine

enum NaturalLanguageAPI {
    
    static let baseURL = URL(string: "https://language.googleapis.com")!
    
    case analyzeSentiment(input: AnalyzeInput)
    
    func request(apiKey: String) -> URLRequest {
        switch self {
        case let .analyzeSentiment(input):
            var components = URLComponents()
            components.scheme = Self.baseURL.scheme
            components.host = Self.baseURL.host
            components.path = Self.baseURL.path + "/v1/documents:analyzeSentiment"
            components.queryItems = [
                .init(name: "key", value: apiKey)
            ]
            
            var request = URLRequest(url: components.url!)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            request.httpBody = try? AnalyzeSentimentRequest.map(input: input)
            return request
        }
    }
}

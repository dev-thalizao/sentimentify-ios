//
//  NaturalLanguageAnalyzeLoader.swift
//  GoogleAnalyzeInfrastructure
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation
import SentimentifyEngine

public final class NaturalLanguageAnalyzeLoader: AnalyzeLoader {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient, apiKey: String) {
        self.client = client
    }
    
    public func analyze(using input: AnalyzeInput, completion: @escaping (AnalyzeLoader.Result) -> Void) {
        let endpoint = NaturalLanguageAPI.analyzeSentiment(input: input)
        client.execute(endpoint.request()) { (result) in
            completion(result.flatMap { (data, response) in
                do {
                    return .success(try AnalyzeSentimentResponse.map(data))
                } catch {
                    return .failure(error)
                }
            })
        }
    }
}

//
//  TwitterSearchLoader.swift
//  TwitterSearchInfrastructure
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation
import SentimentifyEngine

public final class TwitterSearchLoader: SearchLoader {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func search(using input: SearchInput, completion: @escaping (SearchLoader.Result) -> Void) {
        let endpoint = TwitterAPI.userTimeline(input: input)
        client.execute(endpoint.request()) { (result) in
            completion(result.flatMap { (data, response) in
                do {
                    return .success(try TwitterSearchResponse.map(data))
                } catch {
                    return .failure(error)
                }
            })
        }
    }
}

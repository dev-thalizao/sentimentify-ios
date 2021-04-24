//
//  AnalyzeSentimentMapper.swift
//  GoogleAnalyzeInfrastructure
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation
import SentimentifyEngine

final class AnalyzeSentimentResponse {
    
    private init() {}
    
    static func map(_ data: Data) throws -> AnalyzeScore {
        return try JSONDecoder().decode(Root.self, from: data).domain
    }
}

extension AnalyzeSentimentResponse {
    
    private struct Root: Decodable {
        let score: Double
        
        var domain: AnalyzeScore {
            return .init(score: score)
        }
        
        private enum CodingKeys: String, CodingKey {
            case documentSentiment
            case score
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .documentSentiment)
            self.score = try response.decode(Double.self, forKey: .score)
        }
    }
}

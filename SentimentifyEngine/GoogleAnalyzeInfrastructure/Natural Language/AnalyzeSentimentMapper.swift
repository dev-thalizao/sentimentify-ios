//
//  AnalyzeSentimentMapper.swift
//  GoogleAnalyzeInfrastructure
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation
import SentimentifyEngine

final class AnalyzeSentimentMapper {
    
    private init() {}
    
    private struct Root: Decodable {
        let score: Double
        
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
    
    static func map(_ data: Data, response: HTTPURLResponse) throws -> AnalyzeScore {
        let response = try JSONDecoder().decode(Root.self, from: data)
        return .init(score: response.score)
    }
}

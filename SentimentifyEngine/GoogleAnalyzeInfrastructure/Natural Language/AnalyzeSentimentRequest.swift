//
//  AnalyzeSentimentRequest.swift
//  GoogleAnalyzeInfrastructure
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation
import SentimentifyEngine

final class AnalyzeSentimentRequest {
    
    private init() {}
    
    static func map(input: AnalyzeInput) throws -> Data {
        return try JSONEncoder().encode(Root(content: input.content))
    }
}

extension AnalyzeSentimentRequest {
    
    private struct Root: Encodable {
        let content: String
        
        private enum CodingKeys: String, CodingKey {
            case document
            case encodingType
            case content
            case type
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            var request = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .document)
            try request.encode(content, forKey: .content)
            try request.encode("PLAIN_TEXT", forKey: .type)
            try container.encode("UTF8", forKey: .encodingType)
        }
    }
}

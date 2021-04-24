//
//  AnalyzeSentimentRequest.swift
//  GoogleAnalyzeInfrastructure
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation

struct AnalyzeSentimentRequest: Codable, Equatable {
    let document: Document
    let encondingType: String
    
    static func basic(_ content: String) -> AnalyzeSentimentRequest {
        return .init(
            document: .init(content: content, type: "PLAIN_TEXT"),
            encondingType: "UTF8"
        )
    }
}

extension AnalyzeSentimentRequest {
    
    struct Document: Codable, Equatable {
        let content: String
        let type: String
    }
}

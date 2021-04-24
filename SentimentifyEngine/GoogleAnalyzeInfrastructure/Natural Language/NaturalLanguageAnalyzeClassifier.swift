//
//  NaturalLanguageAnalyzeClassifier.swift
//  GoogleAnalyzeInfrastructure
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation
import SentimentifyEngine

final class NaturalLanguageAnalyzeClassifier: AnalyzeClassifier {
    
    func classify(score: AnalyzeScore) -> AnalyzeResult {
        switch score.value {
        case _ where score.value < -0.2:
            return .init(emotion: "😞")
        case _ where score.value < 0.5:
            return .init(emotion: "😐")
        default:
            return .init(emotion: "🤩")
        }
    }
}

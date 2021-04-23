//
//  AnalyzeClassifier.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 23/04/21.
//

import Foundation

public protocol AnalyzeClassifier {
    func classify(score: AnalyzeScore) -> AnalyzeResult
}

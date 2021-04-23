//
//  AnalyzeResult.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 23/04/21.
//

import Foundation

public struct AnalyzeResult: Equatable {
    public let emotion: String
    
    public init(emotion: String) {
        self.emotion = emotion
    }
}

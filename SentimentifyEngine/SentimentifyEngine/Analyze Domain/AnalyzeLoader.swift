//
//  AnalyzeLoader.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 23/04/21.
//

import Foundation

public protocol AnalyzeLoader {
    typealias Result = Swift.Result<AnalyzeScore, Error>
    
    func analyze(using input: AnalyzeInput, completion: @escaping (Result) -> Void)
}

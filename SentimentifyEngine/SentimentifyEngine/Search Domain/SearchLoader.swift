//
//  SearchLoader.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 21/04/21.
//

import Foundation

public protocol SearchLoader {
    typealias Result = Swift.Result<[SearchResult], Error>
    
    func search(using term: SearchInput, completion: @escaping (Result) -> Void)
}

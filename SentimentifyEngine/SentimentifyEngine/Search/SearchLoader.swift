//
//  SearchLoader.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 21/04/21.
//

import Foundation

public protocol SearchLoader {
    func search(using term: String, completion: @escaping (Result<SearchItem, Error>) -> Void)
}

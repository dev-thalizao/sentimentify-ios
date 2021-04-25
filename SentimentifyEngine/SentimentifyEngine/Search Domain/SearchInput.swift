//
//  SearchTerm.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 22/04/21.
//

import Foundation

public struct SearchInput {
    
    public let term: String
    public let after: String?
    
    public init(term: String, after: String? = nil) {
        self.term = term
        self.after = after
    }
}

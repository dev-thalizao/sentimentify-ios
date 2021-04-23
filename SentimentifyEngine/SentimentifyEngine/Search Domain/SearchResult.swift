//
//  SearchResult.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 21/04/21.
//

import Foundation

public struct SearchResult: Equatable {
    public let content: Content
    public let author: Author
    
    public init(content: Content, author: Author) {
        self.content = content
        self.author = author
    }
}

extension SearchResult {
    
    public struct Content: Equatable {
        public let id: String
        public let text: String
        public let createdAt: Date
        
        public init(id: String, text: String, createdAt: Date) {
            self.id = id
            self.text = text
            self.createdAt = createdAt
        }
    }
}

extension SearchResult {
    
    public struct Author: Equatable {
        public let name: String
        public let username: String
        public let photo: URL?
        
        public init(name: String, username: String, photo: URL?) {
            self.name = name
            self.username = username
            self.photo = photo
        }
    }
}

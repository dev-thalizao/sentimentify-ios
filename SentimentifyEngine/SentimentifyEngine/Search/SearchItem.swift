//
//  SearchResult.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 21/04/21.
//

import Foundation

public struct SearchItem: Identifiable {
    public typealias ID = String
    
    public let id: String
    public let title: String
    public let subtitle: String
    public let description: String
    public let image: URL?
    public let createdAt: Date
    
    public init(id: SearchItem.ID, title: String, subtitle: String, description: String, image: URL?, createdAt: Date) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.image = image
        self.createdAt = createdAt
    }
}

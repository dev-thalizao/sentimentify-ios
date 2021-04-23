//
//  AnyData.swift
//  SentimentifyEngineTests
//
//  Created by Thales Frigo on 23/04/21.
//

import Foundation
import SentimentifyEngine

func anyCreatedAt() -> Date {
    return .distantPast
}

func anyContent() -> SearchResult.Content {
    return .init(id: "any id", text: "any text", createdAt: anyCreatedAt())
}

func anyAuthor() -> SearchResult.Author {
    return .init(name: "any name", username: "any username", photo: nil)
}

func anySearchResult() -> SearchResult {
    return .init(content: anyContent(), author: anyAuthor())
}

func anySearchResults(_ items: Int = 1) -> [SearchResult] {
    return (0..<items).map { _ in anySearchResult() }
}

func anyError() -> Error {
    return NSError(domain: "unknown", code: -1, userInfo: nil)
}

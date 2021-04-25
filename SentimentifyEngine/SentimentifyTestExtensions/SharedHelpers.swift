//
//  SharedHelpers.swift
//  SentimentifyTestExtensions
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation
import SentimentifyEngine

public func anyCreatedAt() -> Date {
    return .distantPast
}

public func anyURL() -> URL {
    return URL(string: "http://valid-url.com")!
}

public func anyContent() -> SearchResult.Content {
    return .init(id: "any id", text: "any text", createdAt: anyCreatedAt())
}

public func anyAuthor() -> SearchResult.Author {
    return .init(name: "any name", username: "any username", photo: anyURL())
}

public func anySearchResult() -> SearchResult {
    return .init(content: anyContent(), author: anyAuthor())
}

public func anySearchResultArray(_ items: Int = 1) -> [SearchResult] {
    return (0..<items).map { _ in anySearchResult() }
}

public func anySearchResults(_ items: Int = 1, next: (() -> Void)? = nil) -> SearchResults {
    return .init(results: anySearchResultArray(items), nextResults: next)
}

public func anyError() -> Error {
    return NSError(domain: "unknown", code: -1, userInfo: nil)
}

public func happyAnalyzeResult() -> AnalyzeResult {
    return .init(emotion: "🤩")
}

public func neutralAnalyzeResult() -> AnalyzeResult {
    return .init(emotion: "😐")
}

public func sadAnalyzeResult() -> AnalyzeResult {
    return .init(emotion: "😞")
}

public func sadAnalyzeScore() -> AnalyzeScore {
    return .init(score: -0.3)
}

public func neutralAnalyzeScore() -> AnalyzeScore {
    return .init(score: 0.4)
}

public func happyAnalyzeScore() -> AnalyzeScore {
    return .init(score: 0.5)
}

public func anyAnalyzeInput() -> AnalyzeInput {
    return .init(content: "any content")
}

public func anyData() -> Data {
    return Data()
}

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

public func anySearchInput(after: String? = nil) -> SearchInput {
    return .init(term: "any term", after: after)
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

public func makeTwitterSearchResponse() -> Data {
    let json: [[String: Any]] = [
        [
            "created_at": "Fri Dec 07 18:20:12 +0000 2018",
            "id_str": "1071107120219783168",
            "text": "I just skipped 19 minutes of simple-minded donkey work by generating 164 lines of #swift with @quicktypeio 🎉😎 https://t.co/hJL5EpUVqG",
            "user": [
                "name": "Thales Frigo",
                "screen_name": "thalesfrigo",
                "profile_image_url": "http://pbs.twimg.com/profile_images/602296681070239744/7v7JRjlI_normal.jpg"
            ]
        ]
    ]
    
    return try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
}

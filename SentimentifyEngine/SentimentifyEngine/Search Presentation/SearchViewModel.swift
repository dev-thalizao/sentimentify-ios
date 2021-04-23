//
//  SearchViewModel.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 23/04/21.
//

import Foundation

public struct SearchViewModel: Equatable {
    public let results: [SearchResultViewModel]
    
    public static func map(
        _ results: [SearchResult],
        currentDate: Date = .init(),
        calendar: Calendar = .current,
        locale: Locale = .current
    ) -> SearchViewModel {
        let formatter = RelativeDateTimeFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        
        return SearchViewModel(results: results.map({ result in
            SearchResultViewModel(
                title: result.author.name,
                subtitle: result.author.username,
                content: result.content.text,
                image: result.author.photo,
                createdAt: formatter.localizedString(
                    for: result.content.createdAt,
                    relativeTo: currentDate
                )
            )
        }))
    }
}

public struct SearchResultViewModel: Equatable {
    public let title: String
    public let subtitle: String
    public let content: String
    public let image: URL?
    public let createdAt: String
}

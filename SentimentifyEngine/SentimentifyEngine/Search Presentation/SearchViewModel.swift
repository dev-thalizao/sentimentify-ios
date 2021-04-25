//
//  SearchViewModel.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 23/04/21.
//

import Foundation

public struct SearchViewModel {
    
    public let results: [SearchResultViewModel]
    public let nextResults: NextResultsCompletion?
    
    public init(results: [SearchResultViewModel], nextResults: NextResultsCompletion? = nil) {
        self.results = results
        self.nextResults = nextResults
    }
    
    public static func map(
        _ search: SearchResults,
        currentDate: Date = .init(),
        calendar: Calendar = .current,
        locale: Locale = .current
    ) -> SearchViewModel {
        let formatter = RelativeDateTimeFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        
        return SearchViewModel(
            results: search.results.map({ result in
                SearchResultViewModel(
                    id: result.content.id,
                    title: result.author.name,
                    subtitle: result.author.username,
                    content: result.content.text,
                    image: result.author.photo,
                    createdAt: formatter.localizedString(
                        for: result.content.createdAt,
                        relativeTo: currentDate
                    )
                )
            }),
            nextResults: search.nextResults
        )
    }
}

public struct SearchResultViewModel: Hashable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let content: String
    public let image: URL?
    public let createdAt: String
}

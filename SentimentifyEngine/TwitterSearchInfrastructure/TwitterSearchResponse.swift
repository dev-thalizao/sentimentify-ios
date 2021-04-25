//
//  TwitterSearchResponse.swift
//  TwitterSearchInfrastructure
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation
import SentimentifyEngine

final class TwitterSearchResponse {
    
    private init() {}
    
    static func map(_ data: Data) throws -> [SearchResult] {
        return try JSONDecoder()
            .decode([Root].self, from: data)
            .map(\.searchResult)
    }
}

extension TwitterSearchResponse {
    
    private struct Root: Decodable {
        let id: String
        let createdAt: Date
        let text: String
        let userName: String
        let userScreenName: String
        let userImage: URL?
        
        var searchResult: SearchResult {
            return SearchResult(
                content: .init(id: id, text: text, createdAt: createdAt),
                author: .init(name: userName, username: userScreenName, photo: userImage)
            )
        }
        
        private enum CodingKeys: String, CodingKey {
            case id = "id_str"
            case createdAt = "created_at"
            case text
            case user
            case userName = "name"
            case userScreenName = "screen_name"
            case userImage = "profile_image_url"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            self.text = try container.decode(String.self, forKey: .text)
            
            let createdAt = try container.decode(String.self, forKey: .createdAt)
            if let date = DateFormatter.twitterDateFormat.date(from: createdAt) {
                self.createdAt = date
            } else {
                throw DecodingError.dataCorruptedError(
                    forKey: .createdAt,
                    in: container,
                    debugDescription: "Date string does not match format expected by formatter."
                )
            }
            
            let userContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
            self.userName = try userContainer.decode(String.self, forKey: .userName)
            self.userScreenName = try userContainer.decode(String.self, forKey: .userScreenName)
            
            if let userImage = try userContainer.decodeIfPresent(String.self, forKey: .userImage) {
                self.userImage = URL(string: userImage)
            } else {
                self.userImage = nil
            }
        }
    }
}

//
//  TwitterAuthenticationResponse.swift
//  TwitterSearchInfrastructure
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation

final class TwitterAuthenticationResponse {
    
    private init() {}
    
    static func map(_ data: Data) throws -> TwitterAccessToken {
        return try JSONDecoder().decode(Root.self, from: data).wrapper
    }
}

extension TwitterAuthenticationResponse {
    
    private struct Root: Decodable {
        let accessToken: String
        
        var wrapper: TwitterAccessToken {
            return .init(value: accessToken)
        }
        
        private enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
        }
    }
}

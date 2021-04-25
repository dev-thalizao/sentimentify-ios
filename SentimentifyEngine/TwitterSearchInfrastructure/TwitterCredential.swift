//
//  TwitterCredential.swift
//  TwitterSearchInfrastructure
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation

public struct TwitterCredential {
    
    public let consumerKey: String
    public let consumerSecretKey: String
    
    public init(consumerKey: String, consumerSecretKey: String) {
        self.consumerKey = consumerKey
        self.consumerSecretKey = consumerSecretKey
    }
    
    public func encoded() -> String? {
        return consumerKey
            .appending(":")
            .appending(consumerSecretKey)
            .data(using: String.Encoding.utf8, allowLossyConversion: true)?
            .base64EncodedString()
    }
}

//
//  HTTPURLResponse+Extensions.swift
//  SentimentifyTestExtensions
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation

public extension HTTPURLResponse {
    
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

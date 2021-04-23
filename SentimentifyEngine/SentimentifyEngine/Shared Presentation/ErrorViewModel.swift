//
//  ErrorViewModel.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 23/04/21.
//

import Foundation

public struct ErrorViewModel: Equatable {
    public let message: String?
    
    public init(message: String?) {
        self.message = message
    }
}

//
//  LoadingViewModel.swift
//  SentimentifyEngine
//
//  Created by Thales Frigo on 23/04/21.
//

import Foundation

public struct LoadingViewModel: Equatable {
    public let isLoading: Bool
    
    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }
}

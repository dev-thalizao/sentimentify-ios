//
//  Error+Equatable.swift
//  SentimentifyTestExtensions
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation

public extension Error {
    
    var identifier: String {
        return String(describing: self)
    }
    
    var nsError: NSError {
        return self as NSError
    }
    
    func isEqual(other: Error) -> Bool {
        guard identifier == other.identifier else {
            return false
        }
        
        return nsError.isEqual(other.nsError)
    }
}

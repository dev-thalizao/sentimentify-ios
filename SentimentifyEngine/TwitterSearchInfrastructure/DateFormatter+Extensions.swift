//
//  DateFormatter+Extensions.swift
//  TwitterSearchInfrastructure
//
//  Created by Thales Frigo on 25/04/21.
//

import Foundation

extension DateFormatter {
    
    static let twitterDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

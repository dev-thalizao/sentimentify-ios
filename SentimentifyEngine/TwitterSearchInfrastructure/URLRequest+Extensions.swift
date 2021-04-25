//
//  URLRequest+Extensions.swift
//  TwitterSearchInfrastructure
//
//  Created by Thales Frigo on 24/04/21.
//

import Foundation

extension URLRequest {
    
    func signed(bearer: String) -> URLRequest {
        var mutableRequest = self
        mutableRequest.addValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
        return mutableRequest
    }
}

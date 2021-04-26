//
//  FloatingPoint+Extensions.swift
//  SentimentifyiOS
//
//  Created by Thales Frigo on 25/04/21.
//

import Foundation

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

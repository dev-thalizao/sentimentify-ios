//
//  UIControl+Extensions.swift
//  SentimentifyTestExtensions
//
//  Created by Thales Frigo on 26/04/21.
//

import UIKit

public extension UIControl {
    
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}


//
//  UIControl+Extensions.swift
//  SentimentifyiOSTests
//
//  Created by Thales Frigo on 25/04/21.
//

import UIKit

extension UIControl {
    
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

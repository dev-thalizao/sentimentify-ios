//
//  SearchUseCaseDispatchAfterAdapter.swift
//  SentimentifyApp
//
//  Created by Thales Frigo on 25/04/21.
//

import Foundation
import SentimentifyEngine

final class SearchUseCaseDispatchUniqueAfterAdapter {
    
    private let adaptee: SearchUseCase
    private let dispatchQueue: DispatchQueue
    private var workItem: DispatchWorkItem?
    private var lastText: String?
    
    init(adaptee: SearchUseCase, dispatchQueue: DispatchQueue = .main) {
        self.adaptee = adaptee
        self.dispatchQueue = dispatchQueue
    }
    
    func search(text: String) {
        guard text != lastText else {
            return
        }
        
        lastText = text
        
        workItem?.cancel()
        
        let workItem = DispatchWorkItem { [adaptee] in
            adaptee.search(using: .init(term: text))
        }
        
        self.workItem = workItem
        
        dispatchQueue.asyncAfter(
            deadline: .now() + .milliseconds(750),
            execute: workItem
        )
    }
}

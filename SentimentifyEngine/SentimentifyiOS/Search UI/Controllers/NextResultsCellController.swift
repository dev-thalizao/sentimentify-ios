//
//  NextResultsCellController.swift
//  SentimentifyiOS
//
//  Created by Thales Frigo on 25/04/21.
//

import UIKit

final class NextResultsCellController: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let cell = NextResultsCell()
    private let callback: () -> Void
    private var offsetObserver: NSKeyValueObservation?
    
    public init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay: UITableViewCell, forRowAt indexPath: IndexPath) {
      offsetObserver = tableView.observe(\.contentOffset, options: .new) { [weak self] (tableView, _) in
            guard tableView.isDragging else { return }
            
            self?.reloadIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        offsetObserver = nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        reloadIfNeeded()
    }
    
    private func reloadIfNeeded() {
        guard !cell.isLoading else { return }
        
        callback()
        
        cell.isLoading = true
    }
}

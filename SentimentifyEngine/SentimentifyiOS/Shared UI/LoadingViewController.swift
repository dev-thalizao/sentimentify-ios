//
//  LoadingViewController.swift
//  SentimentifyiOS
//
//  Created by Thales Frigo on 25/04/21.
//

import UIKit

final class LoadingViewController: UIViewController {
    typealias OnHide = (LoadingViewController) -> Void
    
    var onHide: OnHide?
    
    var isLoading: Bool {
        get { spinner.isAnimating }
        set {
            if newValue {
                spinner.startAnimating()
            } else {
                spinner.stopAnimating()
                onHide?(self)
            }
        }
    }
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        view.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}

//
//  ErrorViewController.swift
//  SentimentifyiOS
//
//  Created by Thales Frigo on 25/04/21.
//

import UIKit

final class ErrorViewController: UIViewController {
    typealias OnRetry = (ErrorViewController) -> Void
    
    var onRetry: OnRetry?
    
    var errorMessage: String? {
        get { errorLabel.text }
        set { errorLabel.text = newValue }
    }
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        return label
    }()
    
    private(set) lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Tentar novamente", for: .normal)
        button.addTarget(self, action: #selector(retryButtonDidTapped), for: .touchUpInside)
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            button.centerYAnchor.constraint(equalTo: errorLabel.centerYAnchor)
        ])
        
        return button
    }()
    
    @objc private func retryButtonDidTapped() {
        onRetry?(self)
    }
}

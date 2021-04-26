//
//  ErrorViewController.swift
//  SentimentifyiOS
//
//  Created by Thales Frigo on 25/04/21.
//

import UIKit

final class ErrorViewController: UIViewController {
    typealias OnRetry = (ErrorViewController) -> Void
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Tentar novamente", for: .normal)
        button.addTarget(self, action: #selector(retryButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    var onRetry: OnRetry?
    
    var errorMessage: String? {
        get { errorLabel.text }
        set { errorLabel.text = newValue }
    }
    
   override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureViewHierarchy()
        setupConstraints()
    }
    
    private func configureViewHierarchy() {
        view.addSubview(errorLabel)
        view.addSubview(retryButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            retryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            retryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            retryButton.heightAnchor.constraint(equalToConstant: 50),
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            retryButton.centerXAnchor.constraint(equalTo: errorLabel.centerXAnchor)
        ])
    }
    
    @objc private func retryButtonDidTapped() {
        onRetry?(self)
    }
}

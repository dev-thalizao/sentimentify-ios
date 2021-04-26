//
//  AnalyzeViewController.swift
//  SentimentifyiOS
//
//  Created by Thales Frigo on 25/04/21.
//

import UIKit
import SentimentifyEngine

public final class AnalyzeViewController: UIViewController {
    public typealias OnProccess = () -> Void
    public typealias OnClose = (AnalyzeViewController) -> Void
    
    public var onProccess: OnProccess?
    public var onClose: OnClose?
    
    private lazy var loadingViewController = LoadingViewController()
    private lazy var errorViewController = ErrorViewController()
    private lazy var resultViewController = AnalyzeResultViewController()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Processando análise"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didDismiss)
        )
        onProccess?()
    }
    
    @objc private func didDismiss() {
        onClose?(self)
    }
}

extension AnalyzeViewController: LoadingView {
    
    public func display(viewModel: LoadingViewModel) {
        navigationItem.title = "Processando análise"
        loadingViewController.isLoading = viewModel.isLoading
        if viewModel.isLoading {
            add(loadingViewController)
        } else {
            loadingViewController.remove()
        }
    }
}

extension AnalyzeViewController: ErrorView {
    
    public func display(viewModel: ErrorViewModel) {
        guard let message = viewModel.message else {
            errorViewController.remove()
            return
        }
        
        
        navigationItem.title = "Análise indisponível"
        
        errorViewController.errorMessage = message
        errorViewController.onRetry = { [weak self] errorVC in
            errorVC.remove()
            self?.onProccess?()
        }
    }
}

extension AnalyzeViewController: AnalyzeView {
    
    public func display(viewModel: AnalyzeViewModel) {
        navigationItem.title = "Análise concluída"
        resultViewController.result = viewModel.emotion
        add(resultViewController)
    }
}

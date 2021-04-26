//
//  AnalyzeResultViewController.swift
//  SentimentifyiOS
//
//  Created by Thales Frigo on 25/04/21.
//

import UIKit

final class AnalyzeResultViewController: UIViewController {
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 100)
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        return label
    }()
    
    var result: String? {
        get { resultLabel.text }
        set { resultLabel.text = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateResult()
    }
    
    private func animateResult() {
        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.fromValue = 0
        fadeOut.toValue = 1
        fadeOut.duration = 1
        
        let expandScale = CABasicAnimation()
        expandScale.keyPath = "transform"
        expandScale.valueFunction = CAValueFunction(name: CAValueFunctionName.scale)
        expandScale.fromValue = [0, 0, 0]
        expandScale.toValue = [1, 1, 1]
        expandScale.duration = 1.0
        
        let rotation = CABasicAnimation()
        rotation.keyPath  = "transform.rotation.z"
        rotation.toValue  = CGFloat(360).degreesToRadians
        rotation.duration = 1.0
        
        let fadeAndScale = CAAnimationGroup()
        fadeAndScale.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.4, 0.8, 1.0)
        fadeAndScale.animations = [fadeOut, expandScale, rotation]
        fadeAndScale.duration = 1.0
        
        resultLabel.layer.add(fadeAndScale, forKey: nil)
    }
}

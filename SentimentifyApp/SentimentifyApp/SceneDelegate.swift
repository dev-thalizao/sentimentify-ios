//
//  SceneDelegate.swift
//  SentimentifyApp
//
//  Created by Thales Frigo on 21/04/21.
//

import UIKit
import SentimentifyEngine
import TwitterSearchInfrastructure

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var twitterSearchLoader: TwitterSearchLoader = {
        let loggedClient = LogHTTPClientDecorator(decoratee: httpClient)
        let authorizedClient = TwitterAuthenticatedHTTPClientDecorator(
            decoratee: loggedClient,
            credential: .init(
                consumerKey: "UQvX4lOtRRpDu3vmuVgoaNQmS",
                consumerSecretKey: "m0P8jG6KzPuiXfqJ9vkRvavO1vR46bVsWd5J3bcQf8yDF8ugBL"
            )
        )
        
        return TwitterSearchLoader(client: authorizedClient)
    }()
    
    private lazy var navigationController = UINavigationController(
        rootViewController: SearchUIComposer.searchComposedWith(
            loader: twitterSearchLoader,
            selection: { [weak self] (viewModel) in
                self?.showAnalyze(viewModel.content)
            }
        )
    )
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func showAnalyze(_ content: String) {
        print("showAnalyze with content: \(content)")
    }
}


//
//  SceneDelegate.swift
//  SentimentifyApp
//
//  Created by Thales Frigo on 21/04/21.
//

import UIKit
import SentimentifyEngine
import TwitterSearchInfrastructure
import GoogleAnalyzeInfrastructure

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        return ValidationStatusCodeHTTPClientDecorator(decoratee: client)
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
        let mainQueueDecorator = MainQueueDispatchHTTPClientDecorator(
            decoratee: authorizedClient
        )
        return TwitterSearchLoader(client: mainQueueDecorator)
    }()
    
    private lazy var naturalLanguageSearchLoader: NaturalLanguageAnalyzeLoader = {
        let loggedClient = LogHTTPClientDecorator(decoratee: httpClient)
        let authorizedClient = NaturalLanguageAuthenticatedHTTPClientDecorator(
            decoratee: loggedClient,
            credential: .init(apiKey: "AIzaSyDN4IEqLBS0XK5r-oV9sosWXJfKHBGUP1Y")
        )
        let mainQueueDecorator = MainQueueDispatchHTTPClientDecorator(
            decoratee: authorizedClient
        )
        
        return NaturalLanguageAnalyzeLoader(client: mainQueueDecorator)
    }()
    
    private lazy var naturalLanguageClassifier = NaturalLanguageAnalyzeClassifier()
    
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
        let analyzeVC = AnalyzeUIComposer.analyzeComposedWith(
            content: content,
            loader: naturalLanguageSearchLoader,
            classifier: naturalLanguageClassifier
        )

        self.navigationController.present(
            UINavigationController(rootViewController: analyzeVC),
            animated: true
        )
    }
}


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
        let loggedClient = LogDecorator(client)
        return ValidationStatusCodeHTTPClientDecorator(decoratee: loggedClient)
    }()
    
    private lazy var twitterSearchLoader: TwitterSearchLoader = {
        let authorizedClient = TwitterAuthenticatedHTTPClientDecorator(
            decoratee: httpClient,
            credential: .init(
                consumerKey: "UQvX4lOtRRpDu3vmuVgoaNQmS",
                consumerSecretKey: "m0P8jG6KzPuiXfqJ9vkRvavO1vR46bVsWd5J3bcQf8yDF8ugBL"
            )
        )
        return TwitterSearchLoader(client: authorizedClient)
    }()
    
    private lazy var naturalLanguageSearchLoader: NaturalLanguageAnalyzeLoader = {
        let authorizedClient = NaturalLanguageAuthenticatedHTTPClientDecorator(
            decoratee: httpClient,
            credential: .init(apiKey: "AIzaSyDN4IEqLBS0XK5r-oV9sosWXJfKHBGUP1Y")
        )
        
        return NaturalLanguageAnalyzeLoader(client: authorizedClient)
    }()
    
    private lazy var naturalLanguageClassifier = NaturalLanguageAnalyzeClassifier()
    
    private lazy var navigationController = UINavigationController(
        rootViewController: SearchUIComposer.searchComposedWith(
            loader: twitterSearchLoader,
            selection: showAnalyze
        )
    )
    
    convenience init(httpClient: HTTPClient) {
        self.init()
        self.httpClient = httpClient
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func showAnalyze(_ search: SearchResultViewModel) {
        let analyzeVC = AnalyzeUIComposer.analyzeComposedWith(
            content: search.content,
            loader: naturalLanguageSearchLoader,
            classifier: naturalLanguageClassifier,
            onClose: { $0.dismiss(animated: true) }
        )

        self.navigationController.present(
            UINavigationController(rootViewController: analyzeVC),
            animated: true
        )
    }
}


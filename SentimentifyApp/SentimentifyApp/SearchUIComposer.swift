//
//  SearchUIComposer.swift
//  SentimentifyApp
//
//  Created by Thales Frigo on 25/04/21.
//

import UIKit
import SentimentifyEngine
import SentimentifyiOS

public final class SearchUIComposer {
    
    private init() {}
    
    public static func searchComposedWith(
        loader: SearchLoader,
        selection: @escaping (SearchResultViewModel) -> Void = { _ in }
    ) -> UIViewController {
        let view = SearchViewController()
        let presenter = SearchPresenter(
            loadingView: WeakRefVirtualProxy(view),
            errorView: WeakRefVirtualProxy(view),
            searchView: WeakRefVirtualProxy(view)
        )
        
        let useCase = SearchUseCase(
            output: MainQueueSearchUseCaseOutputDecorator(decoratee: presenter),
            loader: loader
        )
        
        let adapter = SearchUseCaseDispatchAfterAdapter(adaptee: useCase)
        
        view.onSearch = adapter.search(text:)
        
        return view
    }
}

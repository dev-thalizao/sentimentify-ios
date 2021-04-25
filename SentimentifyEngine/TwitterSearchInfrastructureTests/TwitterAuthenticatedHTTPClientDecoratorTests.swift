//
//  TwitterAuthenticatedHTTPClientDecoratorTests.swift
//  TwitterSearchInfrastructureTests
//
//  Created by Thales Frigo on 24/04/21.
//

import XCTest
import SentimentifyTestExtensions
import SentimentifyEngine
@testable import TwitterSearchInfrastructure

final class TwitterAuthenticatedHTTPClientDecoratorTests: XCTestCase {
    
    func testDecoratorAuthorizeAndSignedRequest() {
        let (sut, client) = makeSUT()
        
        let unauthorizedRequest = TwitterAPI
            .userTimeline(input: .init(term: "thalesfrigo"))
            .request()
        
        let signedRequest = unauthorizedRequest.signed(bearer: "X")
        
        sut.execute(unauthorizedRequest) { _ in }
        
        XCTAssertEqual(client.requests.last, signedRequest)
    }
    
    func testDecoratorAuthorizeOnlyOneFirstTime() {
        let (sut, client) = makeSUT()
        
        let request = TwitterAPI
            .userTimeline(input: .init(term: "thalesfrigo"))
            .request()
        
        sut.execute(request) { _ in }
        sut.execute(request) { _ in }
        
        XCTAssertEqual(client.requests.compactMap(\.url).map(\.path), [
            "/oauth2/token",
            "/1.1/statuses/user_timeline.json",
            "/1.1/statuses/user_timeline.json"
        ])
    }
    
    private func makeSUT() -> (
        sut: TwitterAuthenticatedHTTPClientDecorator,
        client: HTTPClientStub
    ) {
        let client = HTTPClientStub { (request) -> Result<(Data, HTTPURLResponse), Error> in
            switch request.url?.path {
            case "/oauth2/token":
                return .success((makeAuthorizationResponse(), .OK))
            case "/1.1/statuses/user_timeline.json":
                return .success((Data(), .OK))
            default:
                return .failure(anyError())
            }
        }
        
        let sut = TwitterAuthenticatedHTTPClientDecorator(
            decoratee: client,
            credential: makeCredential()
        )
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return (sut, client)
    }
}

private func makeCredential() -> TwitterCredential {
    return .init(consumerKey: "consumerKey", consumerSecretKey: "consumerSecretKey")
}

private func makeAuthorizationResponse() -> Data {
    let json: [String: Any] = [
        "token_type": "bearer",
        "access_token": "X"
    ]
    return try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
}

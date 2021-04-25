//
//  TwitterAPITests.swift
//  TwitterSearchInfrastructureTests
//
//  Created by Thales Frigo on 24/04/21.
//

import XCTest
import SentimentifyTestExtensions
@testable import TwitterSearchInfrastructure

final class TwitterAPITests: XCTestCase {
    
    func testAuthenticationEndpoint() {
        let credential = TwitterCredential(consumerKey: "username", consumerSecretKey: "password", grantType: "client_credentials")
        let request = TwitterAPI.authentication(credential: credential).request()

        let contentType = request.allHTTPHeaderFields?.first(where: { $0.key == "Content-Type" })
        let accept = request.allHTTPHeaderFields?.first(where: { $0.key == "Accept" })
        let authorization = request.allHTTPHeaderFields?.first(where: { $0.key == "Authorization" })
            
        XCTAssertEqual(
            request.url!,
            URL(string: "https://api.twitter.com/oauth2/token?grant_type=client_credentials")!
        )
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(contentType?.value, "application/json")
        XCTAssertEqual(accept?.value, "application/json")
        XCTAssertEqual(authorization?.value, "Basic dXNlcm5hbWU6cGFzc3dvcmQ=") //username:password
    }
    
    func testFirstPageOfUserTimelineEndpoint() {
        let request = TwitterAPI
            .userTimeline(input: .init(term: "thalizao"))
            .request()

        let contentType = request.allHTTPHeaderFields?.first(where: { $0.key == "Content-Type" })
        let accept = request.allHTTPHeaderFields?.first(where: { $0.key == "Accept" })
        
        XCTAssertEqual(
            request.url!,
            URL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=thalizao&count=10")!
        )
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(contentType?.value, "application/json")
        XCTAssertEqual(accept?.value, "application/json")
    }
    
    func testNextPageOfUserTimelineEndpoint() {
        let request = TwitterAPI
            .userTimeline(input: .init(term: "thalizao", after: "10002"))
            .request()

        let contentType = request.allHTTPHeaderFields?.first(where: { $0.key == "Content-Type" })
        let accept = request.allHTTPHeaderFields?.first(where: { $0.key == "Accept" })
        
        XCTAssertEqual(
            request.url!,
            URL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=thalizao&count=10&max_id=10002")!
        )
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(contentType?.value, "application/json")
        XCTAssertEqual(accept?.value, "application/json")
    }
}

//
//  SearchAnalyzeAcceptanceTest.swift
//  SentimentifyAppTests
//
//  Created by Thales Frigo on 26/04/21.
//

import XCTest
import SentimentifyEngine
import SentimentifyiOS
import SentimentifyTestExtensions
@testable import SentimentifyApp

final class TwitterSearchAndGoogleAnalyzeAcceptanceTest: XCTestCase {
    
    func testTapOnTwitterSearchReachGoogleAnalyze() throws {
        let sut = launch(httpClient: success())
        
        sut.loadViewIfNeeded()
        
        let searchController = UISearchController()
        searchController.searchBar.text = "thalesfrigo"
        
        let exp = XCTestExpectation(description: "Should load and display childs")
        
        sut.updateSearchResults(for: searchController)
        
        let result = XCTWaiter.wait(for: [exp], timeout: 1.5)
        if result == XCTWaiter.Result.timedOut {
            let resultsVC = try XCTUnwrap(sut.children.first(where: { $0 is UITableViewController }) as? UITableViewController)
            
            (0..<10).forEach { (row) in
                XCTAssertTrue(resultsVC.tableView.cell(indexPath: .init(row: row, section: 0)) is SearchResultCell)
            }
            
            XCTAssertTrue(resultsVC.tableView.cell(indexPath: .init(row: 10, section: 0)) is NextResultsCell)
            
            sut.onSelection?(makeSearchResultViewModel())
            RunLoop.current.run(until: Date())
            
            let analyzeNC = sut.navigationController?.presentedViewController as? UINavigationController
            
            XCTAssertTrue(analyzeNC?.topViewController is AnalyzeViewController)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    private func launch(httpClient: HTTPClient) -> SearchViewController {
        let scene = SceneDelegate(httpClient: httpClient)
        scene.window = UIWindow(frame: UIScreen.main.bounds)
        scene.configureWindow()
        
        let navigationController = scene.window!.rootViewController as! UINavigationController
        return navigationController.topViewController as! SearchViewController
    }
    
    private func success() -> HTTPClient {
        let stub = HTTPClientStub { (request) -> Result<(Data, HTTPURLResponse), Error> in
            switch request.url?.path {
            case "/oauth2/token":
                return .success((makeTwitterAuthorizationResponse(), .OK))
            case "/1.1/statuses/user_timeline.json":
                return .success((makeTwitterTimelineResponse(), .OK))
            case "/v1/documents:analyzeSentiment":
                return .success((makeAnalyzeSentimentResponse(), .OK))
            default:
                return .failure(anyError())
            }
        }
        return stub
    }
}

private func makeTwitterAuthorizationResponse() -> Data {
    let json: [String: Any] = [
        "token_type": "bearer",
        "access_token": "X"
    ]
    return try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
}

private func makeAnalyzeSentimentResponse() -> Data {
    let json: [String: Any] = [
        "document": [
            "score": 0.6
        ]
    ]
    return try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
}

private func makeSearchResultViewModel() -> SearchResultViewModel {
    return .init(
        id: "1322795108190707715",
        title: "Sir @T",
        subtitle: "t",
        content: "7 years ago yesterday, showed up to @Nov_Project_SF. Last year: https://t.co/vXjulwpf4R\n\nYesterday was a rest day,… https://t.co/fcQ6bTKiVA",
        image: URL(string: "http://pbs.twimg.com/profile_images/423350922408767488/nlA_m2WH_normal.jpeg")!,
        createdAtReadable: "",
        createdAt: .init()
    )
}

private func makeTwitterTimelineResponse() -> Data {
    let json: [[String: Any]] = [
        [
            "id_str": "11322795108190707715",
            "text": "7 years ago yesterday, showed up to @Nov_Project_SF. Last year: https://t.co/vXjulwpf4R\n\nYesterday was a rest day,… https://t.co/fcQ6bTKiVA",
            "created_at": "Sun Nov 01 06:58:24 +0000 2020",
            "user": [
                "name": "Sir @T",
                "screen_name": "t",
                "profile_image_url": "http://pbs.twimg.com/profile_images/423350922408767488/nlA_m2WH_normal.jpeg",
            ]
        ],
        [
            "id_str": "21322795108190707715",
            "text": "7 years ago yesterday, showed up to @Nov_Project_SF. Last year: https://t.co/vXjulwpf4R\n\nYesterday was a rest day,… https://t.co/fcQ6bTKiVA",
            "created_at": "Sun Nov 01 06:58:24 +0000 2020",
            "user": [
                "name": "Sir @T",
                "screen_name": "t",
                "profile_image_url": "http://pbs.twimg.com/profile_images/423350922408767488/nlA_m2WH_normal.jpeg",
            ]
        ],
        [
            "id_str": "31322795108190707715",
            "text": "7 years ago yesterday, showed up to @Nov_Project_SF. Last year: https://t.co/vXjulwpf4R\n\nYesterday was a rest day,… https://t.co/fcQ6bTKiVA",
            "created_at": "Sun Nov 01 06:58:24 +0000 2020",
            "user": [
                "name": "Sir @T",
                "screen_name": "t",
                "profile_image_url": "http://pbs.twimg.com/profile_images/423350922408767488/nlA_m2WH_normal.jpeg",
            ]
        ],
        [
            "id_str": "41322795108190707715",
            "text": "7 years ago yesterday, showed up to @Nov_Project_SF. Last year: https://t.co/vXjulwpf4R\n\nYesterday was a rest day,… https://t.co/fcQ6bTKiVA",
            "created_at": "Sun Nov 01 06:58:24 +0000 2020",
            "user": [
                "name": "Sir @T",
                "screen_name": "t",
                "profile_image_url": "http://pbs.twimg.com/profile_images/423350922408767488/nlA_m2WH_normal.jpeg",
            ]
        ],
        [
            "id_str": "51322795108190707715",
            "text": "7 years ago yesterday, showed up to @Nov_Project_SF. Last year: https://t.co/vXjulwpf4R\n\nYesterday was a rest day,… https://t.co/fcQ6bTKiVA",
            "created_at": "Sun Nov 01 06:58:24 +0000 2020",
            "user": [
                "name": "Sir @T",
                "screen_name": "t",
                "profile_image_url": "http://pbs.twimg.com/profile_images/423350922408767488/nlA_m2WH_normal.jpeg",
            ]
        ],
        [
            "id_str": "61322795108190707715",
            "text": "7 years ago yesterday, showed up to @Nov_Project_SF. Last year: https://t.co/vXjulwpf4R\n\nYesterday was a rest day,… https://t.co/fcQ6bTKiVA",
            "created_at": "Sun Nov 01 06:58:24 +0000 2020",
            "user": [
                "name": "Sir @T",
                "screen_name": "t",
                "profile_image_url": "http://pbs.twimg.com/profile_images/423350922408767488/nlA_m2WH_normal.jpeg",
            ]
        ],
        [
            "id_str": "71322795108190707715",
            "text": "7 years ago yesterday, showed up to @Nov_Project_SF. Last year: https://t.co/vXjulwpf4R\n\nYesterday was a rest day,… https://t.co/fcQ6bTKiVA",
            "created_at": "Sun Nov 01 06:58:24 +0000 2020",
            "user": [
                "name": "Sir @T",
                "screen_name": "t",
                "profile_image_url": "http://pbs.twimg.com/profile_images/423350922408767488/nlA_m2WH_normal.jpeg",
            ]
        ],
        [
            "id_str": "8322795108190707715",
            "text": "7 years ago yesterday, showed up to @Nov_Project_SF. Last year: https://t.co/vXjulwpf4R\n\nYesterday was a rest day,… https://t.co/fcQ6bTKiVA",
            "created_at": "Sun Nov 01 06:58:24 +0000 2020",
            "user": [
                "name": "Sir @T",
                "screen_name": "t",
                "profile_image_url": "http://pbs.twimg.com/profile_images/423350922408767488/nlA_m2WH_normal.jpeg",
            ]
        ],
        [
            "id_str": "91322795108190707715",
            "text": "7 years ago yesterday, showed up to @Nov_Project_SF. Last year: https://t.co/vXjulwpf4R\n\nYesterday was a rest day,… https://t.co/fcQ6bTKiVA",
            "created_at": "Sun Nov 01 06:58:24 +0000 2020",
            "user": [
                "name": "Sir @T",
                "screen_name": "t",
                "profile_image_url": "http://pbs.twimg.com/profile_images/423350922408767488/nlA_m2WH_normal.jpeg",
            ]
        ],
        [
            "id_str": "10322795108190707715",
            "text": "7 years ago yesterday, showed up to @Nov_Project_SF. Last year: https://t.co/vXjulwpf4R\n\nYesterday was a rest day,… https://t.co/fcQ6bTKiVA",
            "created_at": "Sun Nov 01 06:58:24 +0000 2020",
            "user": [
                "name": "Sir @T",
                "screen_name": "t",
                "profile_image_url": "http://pbs.twimg.com/profile_images/423350922408767488/nlA_m2WH_normal.jpeg",
            ]
        ]
    ]
    return try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
}

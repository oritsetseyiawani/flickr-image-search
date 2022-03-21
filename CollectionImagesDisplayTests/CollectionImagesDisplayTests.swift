//
//  CollectionImagesDisplayTests.swift
//  CollectionImagesDisplayTests
//
//  Created by Melvyn Awani on 17/03/2022.
//

import XCTest
@testable import CollectionImagesDisplay

class CollectionImagesDisplayTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNetworkAPICall() throws {
        // GIVEN
        var mockNetworkManager:MockNetworkManager!
        var homeViewModel: HomeViewModel!
        
        
        let homeViewController = HomeViewController()
    //    homeViewModel = HomeViewModel(delegate: homeViewController)
        
        mockNetworkManager = MockNetworkManager()
        
        homeViewModel.networkManager = mockNetworkManager as! NetworkManager
        mockNetworkManager.performRequest(requestUrl: "dummy")
        // WHEN
        // THEN
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

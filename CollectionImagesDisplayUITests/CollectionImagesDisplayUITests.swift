//
//  CollectionImagesDisplayUITests.swift
//  CollectionImagesDisplayUITests
//
//  Created by Melvyn Awani on 18/03/2022.
//

import XCTest

class CollectionImagesDisplayUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHomeNavigationBarTitleIsCorrect() throws {
        let app = XCUIApplication()
        app.launch()
        let homeNavigationBarTitle =  app.staticTexts["Image Finder"].label
        XCTAssertEqual(homeNavigationBarTitle, "Image Finder")
    }
    
    func testSearchBarFunctionality() throws {
        let app = XCUIApplication()
        app.launch()
        let searchBar = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .searchField).element
        searchBar.tap()
        searchBar.typeText("Luxury")
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        let collectionViewsQuery = XCUIApplication().collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.tap()
        func swipeUpFromThirdElement(){
            collectionViewsQuery.children(matching: .cell).element(boundBy: 3).children(matching: .other).element.swipeUp()
        }
        swipeUpFromThirdElement()
        swipeUpFromThirdElement()
        swipeUpFromThirdElement()
        swipeUpFromThirdElement()
        swipeUpFromThirdElement()
        
        XCTAssertEqual(app.searchFields.count, 1)
        XCTAssertEqual(searchBar.placeholderValue!, "Search")
        
    }
    
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

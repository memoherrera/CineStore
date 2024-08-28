//
//  CineStoreAppUITests.swift
//  CineStoreAppUITests
//
//  Created by Guillermo Herrera on 24/08/24.
//

import XCTest

final class CineStoreAppUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // In UI tests, it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test.
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Clean up
        app = nil
    }

    func testTopRatedMoviesScreenLoading() throws {
        // Given
        let topRatedMoviesTitle = "Top Rated"

        // Verify that the Top Rated screen is displayed
        XCTAssertTrue(app.staticTexts[topRatedMoviesTitle].exists, "The Top Rated Movies title is not visible")

        // Pull to refresh
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeDown()
        XCTAssertTrue(app.activityIndicators.firstMatch.exists, "The activity indicator should appear when loading")

        // Wait for data to loads
        let firstMovie = app.buttons.firstMatch
        XCTAssertTrue(firstMovie.waitForExistence(timeout: 5), "The first movie should be displayed after loading")

    }
}

//
//  UIAppearanceManagerTests.swift
//  CineStoreAppTests
//
//  Created by Guillermo Herrera on 24/08/24.
//

import XCTest
@testable import CineStoreApp

final class UIAppearanceManagerTests: XCTestCase {
    
    func testConfigureNavigationBarWithMock() {
        // Given
        let mockNavigationBar = MockNavigationBar()

        // When
        UIAppearanceManager.configureNavigationBar(navigationBar: mockNavigationBar)

        // Then
        XCTAssertEqual(mockNavigationBar.capturedIsTranslucent, false)
        XCTAssertEqual(mockNavigationBar.capturedTintColor, UIColor.backgroundPrimary)
        XCTAssertNotNil(mockNavigationBar.capturedStandardAppearance)
        XCTAssertEqual(mockNavigationBar.capturedStandardAppearance?.backgroundColor, UIColor.backgroundPrimary)
    }

    func testConfigureTabBarWithMock() {
        // Given
        let mockTabBar = MockTabBar()

        // When
        UIAppearanceManager.configureTabBar(tabBar: mockTabBar)

        // Then
        XCTAssertEqual(mockTabBar.capturedTintColor, UIColor.accent)
        XCTAssertEqual(mockTabBar.capturedBarTintColor, UIColor.black)
        XCTAssertEqual(mockTabBar.capturedUnselectedItemTintColor, UIColor.systemGray)
        XCTAssertNotNil(mockTabBar.capturedStandardAppearance)
        XCTAssertEqual(mockTabBar.capturedStandardAppearance?.backgroundColor, UIColor.backgroundPrimary)
    }

}

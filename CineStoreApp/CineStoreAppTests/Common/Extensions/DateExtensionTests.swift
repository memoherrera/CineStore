//
//  DateExtensionTests.swift
//  CineStoreAppTests
//
//  Created by Guillermo Herrera on 26/08/24.
//
import XCTest

class DateExtensionTests: XCTestCase {

    func testDateToFormattedString() {
        // Given a specific date
        let dateComponents = DateComponents(year: 2024, month: 8, day: 26)
        let calendar = Calendar.current
        guard let date = calendar.date(from: dateComponents) else {
            XCTFail("Failed to create date from components")
            return
        }
        
        // When formatting the date
        let formattedString = date.toFormattedString()
        
        // Then the result should match the expected format
        XCTAssertEqual(formattedString, "2024-08-26", "The date should be formatted as 'yyyy-MM-dd'")
    }

    func testCurrentDateToFormattedString() {
        // Given the current date
        let date = Date()
        
        // When formatting the date
        let formattedString = date.toFormattedString()
        
        // Then the result should match the expected format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let expectedString = dateFormatter.string(from: Date())
        
        XCTAssertEqual(formattedString, expectedString, "The current date should be formatted as 'yyyy-MM-dd'")
    }
}

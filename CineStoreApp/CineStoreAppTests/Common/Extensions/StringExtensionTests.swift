//
//  StringExtensionTests.swift
//  CineStoreAppTests
//
//  Created by Guillermo Herrera on 26/08/24.
//

import XCTest

class StringExtensionTests: XCTestCase {

    func testLimitedSubstringWithShortString() {
        // Given
        let text = "Short string"
        
        // When
        let result = text.limitedSubstring(maxLength: 50)
        
        // Then
        XCTAssertEqual(result, text, "The string should remain unchanged when it's shorter than the maximum length.")
    }
    
    func testLimitedSubstringWithLongStringEndingWithDot() {
        // Given
        let text = "This is a sentence that ends with a period. This part should not appear."
        
        // When
        let result = text.limitedSubstring(maxLength: 50)
        
        // Then
        XCTAssertEqual(result, "This is a sentence that ends with a period", "The string should be truncated at the last period within the limit.")
    }
    
    func testLimitedSubstringWithLongStringWithoutDot() {
        // Given
        let text = "This is a long string without any periods that needs to be truncated with an ellipsis."
        
        // When
        let result = text.limitedSubstring(maxLength: 50)
        
        // Then
        XCTAssertEqual(result, "This is a long string without any periods that nee...", "The string should be truncated with an ellipsis when no period is found.")
    }
    
    func testLimitedSubstringWithDefaultMaxLength() {
        // Given
        let text = "This string should be truncated at the default length of 120 characters. It has more text than needed to reach that limit."
        
        // When
        let result = text.limitedSubstring()
        
        // Then
        XCTAssertEqual(result, "This string should be truncated at the default length of 120 characters", "The string should be truncated at the default limit with an ellipsis.")
    }
    
    func testLimitedSubstringFailCase() {
        // Given
        let text = "This string is intentionally incorrect for the test"
        
        // When
        let result = text.limitedSubstring(maxLength: 20)
        
        // Then
        XCTAssertNotEqual(result, text, "This test should fail if the string is not truncated correctly.")
    }
}

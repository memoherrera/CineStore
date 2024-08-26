//
//  String+Extension.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 26/08/24.
//

import Foundation

public extension String {
    func limitedSubstring(maxLength: Int = 120) -> String {
        // Check if the string is shorter than or equal to the maxLength
        if self.count <= maxLength {
            return self
        }
        
        // Get the substring up to the maxLength
        let endIndex = self.index(self.startIndex, offsetBy: maxLength)
        let substring = String(self[..<endIndex])
        
        // Check if the substring contains a "." character
        if let lastDotIndex = substring.lastIndex(of: ".") {
            return String(substring[..<lastDotIndex])
        }
        
        // If no "." found before maxLength, add "..." at the end
        return substring + "..."
    }
}

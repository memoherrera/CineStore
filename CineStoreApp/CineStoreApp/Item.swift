//
//  Item.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 24/08/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

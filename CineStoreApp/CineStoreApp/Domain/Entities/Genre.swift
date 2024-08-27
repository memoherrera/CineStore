//
//  Genre.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 26/08/24.
//

import Foundation
import Then

struct Genre: Identifiable {
    var id: Int
    var name: String
}

extension Genre: Then, Equatable {
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Genre: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id, name
    }
}

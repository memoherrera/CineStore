//
//  SpokenLanguage.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 26/08/24.
//

import Foundation

struct SpokenLanguage: Identifiable {
    var id: String
    var englishName: String
    var name: String
}

extension SpokenLanguage: Equatable {
    static func == (lhs: SpokenLanguage, rhs: SpokenLanguage) -> Bool {
        return lhs.id == rhs.id
    }
}

extension SpokenLanguage: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case id = "iso_639_1"
        case englishName = "english_name"
    }
}

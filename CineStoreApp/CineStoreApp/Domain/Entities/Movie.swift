//
//  Movie.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 25/08/24.
//

import Foundation
import Then

struct MovieResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    private enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


struct Movie: Identifiable {
    var id: Int
    var title = ""
    var genres: [Int] = []
    var overview = ""
    var popularity = 0.0
    var posterPath: String? = ""
    var voteAverage = 0.0
    var releaseDate = ""
    
    // TODO: Check Overloads
    var posterUrl: String {
        return "\(GlobalConfig.MovieDB.imageUrl)/\(posterPath ?? "")"
    }
}

extension Movie: Then, Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }

    init() {
        self.init(id: 0)
    }
}

extension Movie: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case genres = "genre_ids"
    }
}


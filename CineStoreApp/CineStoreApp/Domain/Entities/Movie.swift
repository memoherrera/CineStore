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
    var genres: [Genre]? = []
    var genreIds: [Int]? = []
    var overview = ""
    var popularity = 0.0
    var posterPath: String? = ""
    var backdropPath: String? = ""
    var voteAverage = 0.0
    var releaseDate = ""
    var status: String? = ""
    var languages: [SpokenLanguage]? = []
    
    var posterUrl: String {
        return "\(GlobalConfig.MovieDB.imageUrl)/\(posterPath ?? "")"
    }
    
    var backdropUrl: String {
        return "\(GlobalConfig.MovieDB.imageUrl)/\(backdropPath ?? "")"
    }
    
    func fullLanguagesString() -> String {
        guard let languages = self.languages else {
            return ""
        }
        return languages.map{ $0.englishName }.joined(separator: ",")
    }
    
    func fullGenresString() -> String {
        guard let genres = self.genres else {
            return ""
        }
        return genres.map{ $0.name }.joined(separator: ",")
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
        case id, title, overview, popularity, genres, status
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case backdropPath = "backdrop_path"
        case languages = "spoken_languages"
    }
}


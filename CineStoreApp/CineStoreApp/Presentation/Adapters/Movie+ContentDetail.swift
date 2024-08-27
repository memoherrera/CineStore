//
//  Movie+ContentDetail.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 27/08/24.
//

import Foundation

extension Movie {
    func toContentDetail() -> ContentDetail {
        return.init(id: self.id,
                    title: self.title,
                    status: self.status ?? "no status provided",
                    releaseDate: self.releaseDate,
                    voteAverage: self.voteAverage,
                    popularity: self.popularity,
                    body: self.overview,
                    genres: self.fullGenresString(),
                    languages: self.fullLanguagesString(),
                    imagePosterUrl: self.posterUrl,
                    imageBackdropUrl: self.backdropUrl)
    }
}

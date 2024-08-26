//
//  FavoritedMovie.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 24/08/24.
//

import Foundation
import SwiftData

@Model class FavoriteMovie {
    var id: String
    var title: String
    var createdDate: Date
    var movieId: String
    
   init(id: String, title: String, createdDate: Date, movieId: String) {
        self.id = id
        self.title = title
        self.createdDate = createdDate
        self.movieId = movieId
    }
}

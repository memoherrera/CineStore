//
//  MovieBDAPIProtocol.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 25/08/24.
//

import Foundation

protocol MovieDBAPIProtocol {
    func fetchTopRatedMovies(page: Int) async throws -> MovieResponse
    func fetchNowPlayingMovies(minDate: String, maxDate: String, page: Int) async throws -> MovieResponse
    func fetchMovieDetails(movieID: Int) async throws -> Movie
}

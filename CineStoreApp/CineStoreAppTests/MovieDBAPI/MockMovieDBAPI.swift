//
//  MockMovieDBAPI.swift
//  CineStoreAppTests
//
//  Created by Guillermo Herrera on 25/08/24.
//

import Foundation
@testable import CineStoreApp

class MockMovieDBAPI: MovieDBAPIProtocol {
    var topRatedMoviesResponse: MovieResponse?
    var nowPlayingMoviesResponse: MovieResponse?
    var movieDetailsResponse: Movie?
    var shouldThrowError = false
    
    func fetchTopRatedMovies(page: Int) async throws -> MovieResponse {
        if shouldThrowError {
            throw NSError(domain: "", code: 1, userInfo: nil)
        }
        return topRatedMoviesResponse ?? MovieResponse(page: 1, results: [], totalPages: 1, totalResults: 1)
    }
    
    func fetchNowPlayingMovies(minDate: String, maxDate: String, page: Int) async throws -> MovieResponse {
        if shouldThrowError {
            throw NSError(domain: "", code: 1, userInfo: nil)
        }
        return nowPlayingMoviesResponse ?? MovieResponse(page: 1, results: [], totalPages: 1, totalResults: 1)
    }
    
    func fetchMovieDetails(movieID: Int) async throws -> Movie {
        if shouldThrowError {
            throw NSError(domain: "", code: 1, userInfo: nil)
        }
        return movieDetailsResponse ?? Movie(id: movieID, title: "Mock Movie", genres: [], overview: "Overview", popularity: 0.0, posterPath: "", voteAverage: 0.0, releaseDate: "")
    }
}

//
//  MockMovieDBAPI.swift
//  CineStoreAppTests
//
//  Created by Guillermo Herrera on 25/08/24.
//

import Foundation
@testable import CineStoreApp

class MockMovieDBAPI: MovieDBAPIProtocol {
    var topRatedMoviesResult: Result<MovieResponse, Error>?
    var nowPlayingMoviesResult: Result<MovieResponse, Error>?
    var movieDetailResult: Result<Movie, Error>?
    
    func fetchTopRatedMovies(page: Int) async throws -> MovieResponse {
        if let result = topRatedMoviesResult {
            switch result {
            case .success(let response):
                return response
            case .failure(let error):
                throw error
            }
        }
        throw MovieRepositoryError.unknown
    }
    
    func fetchNowPlayingMovies(minDate: String, maxDate: String, page: Int) async throws -> MovieResponse {
        if let result = nowPlayingMoviesResult {
            switch result {
            case .success(let response):
                return response
            case .failure(let error):
                throw error
            }
        }
        throw MovieRepositoryError.unknown
    }
    
    func fetchMovieDetails(movieID: Int) async throws -> Movie {
        if let result = movieDetailResult {
            switch result {
            case .success(let movie):
                return movie
            case .failure(let error):
                throw error
            }
        }
        throw MovieRepositoryError.unknown
    }
}

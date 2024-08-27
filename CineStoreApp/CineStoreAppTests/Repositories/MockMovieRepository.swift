//
//  MockMovieRepository.swift
//  CineStoreAppTests
//
//  Created by Guillermo Herrera on 26/08/24.
//
import Combine
import Foundation
@testable import CineStoreApp

class MockMovieRepository: MovieRepositoryProtocol {
    
    var topRatedMoviesResult: Result<MovieResponse, Error>?
    var nowPlayingMoviesResult: Result<MovieResponse, Error>?
    var movieDetailResult: Result<Movie?, Error>?
    
    func getTopRatedMovies(page: Int) -> AnyPublisher<MovieResponse, Error> {
        return Future { promise in
            if let result = self.topRatedMoviesResult {
                promise(result)
            } else {
                promise(.failure(MovieRepositoryError.unknown))
            }
        }.eraseToAnyPublisher()
    }
    
    func getNowPlayingMovies(minDate: String, maxDate: String, page: Int) -> AnyPublisher<MovieResponse, Error> {
        return Future { promise in
            if let result = self.nowPlayingMoviesResult {
                promise(result)
            } else {
                promise(.failure(MovieRepositoryError.unknown))
            }
        }.eraseToAnyPublisher()
    }
    
    func getMovieDetail(id: Int) -> AnyPublisher<Movie?, Error> {
        return Future { promise in
            if let result = self.movieDetailResult {
                promise(result)
            } else {
                promise(.failure(MovieRepositoryError.unknown))
            }
        }.eraseToAnyPublisher()
    }
}



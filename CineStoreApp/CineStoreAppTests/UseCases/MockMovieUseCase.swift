//
//  MockMovieUseCase.swift
//  CineStoreAppTests
//
//  Created by Guillermo Herrera on 26/08/24.
//

import Combine
@testable import CineStoreApp

class MockMovieUseCase: MovieUseCaseProtocol {
    var topRatedMoviesResult: Result<MovieResponse, Error> = .success(MovieResponse.init(page: 1, results: [], totalPages: 1, totalResults: 0))
    var nowPlayingMoviesResult: Result<MovieResponse, Error> = .success(MovieResponse.init(page: 1, results: [], totalPages: 1, totalResults: 0))
    var getMovieDetailResult: Result<Movie?, Error> = .success(nil)
    
    
    func getTopRatedMovies(page: Int) -> AnyPublisher<MovieResponse, Error> {
        return Future { promise in
            promise(self.topRatedMoviesResult)
        }.eraseToAnyPublisher()
    }
    
    func getNowPlayingMovies(minDate: String, maxDate: String, page: Int) -> AnyPublisher<MovieResponse, Error> {
        return Future { promise in
            promise(self.nowPlayingMoviesResult)
        }.eraseToAnyPublisher()
    }
    
    func getMovieDetail(id: Int) -> AnyPublisher<Movie?, Error> {
        return Future { promise in
            promise(self.getMovieDetailResult)
        }.eraseToAnyPublisher()
    }
}

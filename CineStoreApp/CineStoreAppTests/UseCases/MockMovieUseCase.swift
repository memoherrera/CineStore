//
//  MockMovieUseCase.swift
//  CineStoreAppTests
//
//  Created by Guillermo Herrera on 26/08/24.
//

import Combine
@testable import CineStoreApp

class MockMovieUseCase: MovieUseCaseProtocol {
    var topRatedMoviesResult: Result<[Movie], Error> = .success([])
    var nowPlayingMoviesResult: Result<[Movie], Error> = .success([])
    
    
    func getTopRatedMovies(page: Int) -> AnyPublisher<[Movie], Error> {
        return Future { promise in
            promise(self.topRatedMoviesResult)
        }.eraseToAnyPublisher()
    }
    
    func getNowPlayingMovies(minDate: String, maxDate: String, page: Int) -> AnyPublisher<[Movie], Error> {
        return Future { promise in
            promise(self.nowPlayingMoviesResult)
        }.eraseToAnyPublisher()
    }
    
    func getMovieDetail(id: Int) -> AnyPublisher<Movie?, Error> {
        return Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

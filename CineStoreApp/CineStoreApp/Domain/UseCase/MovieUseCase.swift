//
//  MovieUseCase.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 26/08/24.
//

import Foundation
import Combine
import Factory

class MovieUseCase: MovieUseCaseProtocol {
    @Injected(\.movieRepository) var repository
    
    func getTopRatedMovies(page: Int) -> AnyPublisher<MovieResponse, Error> {
        self.repository.getTopRatedMovies(page: page)
    }
    func getNowPlayingMovies(minDate: String, maxDate: String, page: Int) -> AnyPublisher<MovieResponse, Error> {
        self.repository.getNowPlayingMovies(minDate: minDate, maxDate: maxDate, page: page)
    }
    func getMovieDetail(id: Int) -> AnyPublisher<Movie?, Error> {
        self.repository.getMovieDetail(id: id)
    }
}


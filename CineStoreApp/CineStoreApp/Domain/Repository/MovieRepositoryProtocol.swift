//
//  MovieRepository.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 25/08/24.
//

import Foundation
import Combine

protocol MovieRepositoryProtocol {
    func getTopRatedMovies(page: Int) -> AnyPublisher<[Movie], Error>
    func getNowPlayingMovies(minDate: String, maxDate: String, page: Int) -> AnyPublisher<[Movie], Error>
    func getMovieDetail(id: Int) -> AnyPublisher<Movie?, Error>
}

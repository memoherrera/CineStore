//
//  MovieRepository.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 25/08/24.
//

import Foundation
import Combine
import Factory

class MovieRepository: MovieRepositoryProtocol {
    @Injected(\.movieDBAPI) private var api
    
    func getTopRatedMovies(page: Int) -> AnyPublisher<[Movie], Error> {
            Future<[Movie], Error> { [weak self] promise in
                guard let self = self else {
                    return promise(.failure(MovieRepositoryError.deallocatedInstance))
                }
                Task {
                    do {
                        let movieResponse = try await self.api.fetchTopRatedMovies(page: page)
                        promise(.success(movieResponse.results))
                    } catch {
                        promise(.failure(MovieRepositoryError.apiError(error)))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getNowPlayingMovies(minDate: String, maxDate: String, page: Int) -> AnyPublisher<[Movie], Error> {
        Future<[Movie], Error> { [weak self] promise in
            guard let self = self else {
                return promise(.failure(MovieRepositoryError.deallocatedInstance))
            }
            Task {
                do {
                    let movieResponse = try await self.api.fetchNowPlayingMovies(minDate: minDate, maxDate: maxDate, page: page)
                    promise(.success(movieResponse.results))
                } catch {
                    promise(.failure(MovieRepositoryError.apiError(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getMovieDetail(id: Int) -> AnyPublisher<Movie?, Error> {
        Future<Movie?, Error> { [weak self] promise in
            guard let self = self else {
                return promise(.failure(MovieRepositoryError.deallocatedInstance))
            }
            Task {
                do {
                    let movie = try await self.api.fetchMovieDetails(movieID: id)
                    promise(.success(movie))
                } catch {
                    print(error)
                    promise(.failure(MovieRepositoryError.apiError(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

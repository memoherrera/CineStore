//
//  MovieRepositoryTests.swift
//  CineStoreAppTests
//
//  Created by Guillermo Herrera on 25/08/24.
//

import XCTest
import Combine
import Factory
@testable import CineStoreApp

final class MovieRepositoryTests: XCTestCase {
    var repository: MovieRepository!
    var mockAPI: MockMovieDBAPI!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        let mockAPI = MockMovieDBAPI()
        cancellables = []
        
        // Inject the mock API
        Container.shared.movieDBAPI.register { mockAPI }
        self.mockAPI = mockAPI
        repository = MovieRepository()
    }
    
    override func tearDown() {
        repository = nil
        mockAPI = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testGetTopRatedMoviesSuccess() {
        // Given
        let expectedMovies = [
            Movie(id: 1, title: "Mock Movie 1", genres: [28], overview: "Overview 1", popularity: 1000, posterPath: "/path1.jpg", voteAverage: 8.0, releaseDate: "2024-01-01"),
            Movie(id: 2, title: "Mock Movie 2", genres: [12], overview: "Overview 2", popularity: 900, posterPath: "/path2.jpg", voteAverage: 7.5, releaseDate: "2024-02-01")
        ]
        let movieResponse = MovieResponse(page: 1, results: expectedMovies, totalPages: 1, totalResults: 2)
        mockAPI.topRatedMoviesResult = .success(movieResponse)
        
        // When
        let expectation = XCTestExpectation(description: "Fetch top-rated movies")
        
        repository.getTopRatedMovies(page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { movies in
                // Then
                XCTAssertEqual(movies.count, expectedMovies.count)
                XCTAssertEqual(movies, expectedMovies)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetNowPlayingMoviesSuccess() {
        // Given
        let expectedMovies = [
            Movie(id: 3, title: "Now Playing Movie 1", genres: [16, 35], overview: "Overview 3", popularity: 800, posterPath: "/path3.jpg", voteAverage: 7.8, releaseDate: "2024-03-01")
        ]
        let movieResponse = MovieResponse(page: 1, results: expectedMovies, totalPages: 1, totalResults: 1)
        mockAPI.nowPlayingMoviesResult = .success(movieResponse)
        
        // When
        let expectation = XCTestExpectation(description: "Fetch now-playing movies")
        
        repository.getNowPlayingMovies(minDate: "2024-01-01", maxDate: "2024-08-26", page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { movies in
                // Then
                XCTAssertEqual(movies.count, expectedMovies.count)
                XCTAssertEqual(movies, expectedMovies)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetMovieDetailSuccess() {
        // Given
        let expectedMovie = Movie(id: 4, title: "Mock Movie Detail", genres: [18, 80], overview: "Detailed Overview", popularity: 500, posterPath: "/path4.jpg", voteAverage: 9.0, releaseDate: "2024-04-01")
        mockAPI.movieDetailResult = .success(expectedMovie)
        
        // When
        let expectation = XCTestExpectation(description: "Fetch movie detail")
        
        repository.getMovieDetail(id: 4)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { movie in
                // Then
                XCTAssertEqual(movie, expectedMovie)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetTopRatedMoviesFailure() {
        // Given
        let expectedError = MovieRepositoryError.apiError(NSError(domain: "", code: -1, userInfo: nil))
        mockAPI.topRatedMoviesResult = .failure(expectedError)
        
        // When
        let expectation = XCTestExpectation(description: "Fetch top-rated movies with error")
        
        repository.getTopRatedMovies(page: 1)
            .sink(receiveCompletion: { completion in
                // Then
                if case .failure(let error) = completion {
                    XCTAssertTrue(((error as? MovieRepositoryError) != nil))
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure, but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but got success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}

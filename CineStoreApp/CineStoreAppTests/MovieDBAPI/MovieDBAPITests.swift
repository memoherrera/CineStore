//
//  MovieDBAPITests.swift
//  CineStoreAppTests
//
//  Created by Guillermo Herrera on 25/08/24.
//

import XCTest
import Alamofire
@testable import CineStoreApp

class MovieViewModelTests: XCTestCase {
    
    var api: MovieDBAPI!
    var mockSession: Session!
        
    override func setUp() {
        super.setUp()
        
        // Configure Alamofire to use the mock protocol
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = Session(configuration: configuration)
        
        // Inject the mock session into the API client
        let client = APIClient(session: mockSession)
        api = MovieDBAPI(client: client)
    }
    
    override func tearDown() {
        api = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testFetchTopRatedMovies() async throws {
        // Mock JSON response
        // Given
        let jsonData = """
        {
            "page": 1,
            "results": [
                {
                    "id": 1,
                    "title": "Mock Movie",
                    "genres": [28, 12],
                    "overview": "This is a mock movie.",
                    "popularity": 1234.56,
                    "poster_path": "/mock.jpg",
                    "vote_average": 7.5,
                    "release_date": "2024-08-25"
                }
            ],
            "total_pages": 1,
            "total_results": 1
        }
        """.data(using: .utf8)!
        
        // When
        MockURLProtocol.requestHandler = { _ in
            // Mocking the response code 200
            let response = HTTPURLResponse(url: URL(string: "https://api.themoviedb.org/3")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, jsonData)
        }
        
        let movieResponse = try await api.fetchTopRatedMovies()
        
        // Then
        XCTAssertEqual(movieResponse.results.count, 1)
        
        let movie = movieResponse.results.first!
        XCTAssertEqual(movie.id, 1)
        XCTAssertEqual(movie.title, "Mock Movie")
        XCTAssertEqual(movie.genres, [28, 12])
        XCTAssertEqual(movie.overview, "This is a mock movie.")
        XCTAssertEqual(movie.popularity, 1234.56)
        XCTAssertEqual(movie.posterPath, "/mock.jpg")
        XCTAssertEqual(movie.voteAverage, 7.5)
        XCTAssertEqual(movie.releaseDate, "2024-08-25")
    }
    
    func testFetchNowPlayingMovies() async throws {
        // Mock JSON response
        // Given
        let jsonData = """
        {
            "page": 1,
            "results": [
                {
                    "id": 2,
                    "title": "Now Playing Mock Movie",
                    "genres": [16, 35],
                    "overview": "This is a now playing mock movie.",
                    "popularity": 987.65,
                    "poster_path": "/nowplayingmock.jpg",
                    "vote_average": 8.2,
                    "release_date": "2024-09-01"
                }
            ],
            "total_pages": 1,
            "total_results": 1
        }
        """.data(using: .utf8)!
        // When
        MockURLProtocol.requestHandler = { _ in
            // Mocking the response code 200
            let response = HTTPURLResponse(url: URL(string: "https://api.themoviedb.org/3")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, jsonData)
        }
        
        // Then
        let movieResponse = try await api.fetchNowPlayingMovies(minDate: "2024-08-01", maxDate: "2024-09-01")
        XCTAssertEqual(movieResponse.results.count, 1)
        
        let movie = movieResponse.results.first!
        XCTAssertEqual(movie.id, 2)
        XCTAssertEqual(movie.title, "Now Playing Mock Movie")
        XCTAssertEqual(movie.genres, [16, 35])
        XCTAssertEqual(movie.overview, "This is a now playing mock movie.")
        XCTAssertEqual(movie.popularity, 987.65)
        XCTAssertEqual(movie.posterPath, "/nowplayingmock.jpg")
        XCTAssertEqual(movie.voteAverage, 8.2)
        XCTAssertEqual(movie.releaseDate, "2024-09-01")
    }
    
    func testFetchMovieDetails() async throws {
        // Mock JSON response
        // Given
        let jsonData = """
        {
            "id": 3,
            "title": "Mock Movie Details",
            "genres": [18, 80],
            "overview": "This is mock movie details.",
            "popularity": 456.78,
            "poster_path": "/mockdetails.jpg",
            "vote_average": 7.9,
            "release_date": "2024-07-15"
        }
        """.data(using: .utf8)!
        // When
        MockURLProtocol.requestHandler = { _ in
            // Mocking the response code 200
            let response = HTTPURLResponse(url: URL(string: "https://api.themoviedb.org/3")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, jsonData)
        }
        
        let movie = try await api.fetchMovieDetails(movieID: 3)
        
        // Then
        XCTAssertEqual(movie.id, 3)
        XCTAssertEqual(movie.title, "Mock Movie Details")
        XCTAssertEqual(movie.genres, [18, 80])
        XCTAssertEqual(movie.overview, "This is mock movie details.")
        XCTAssertEqual(movie.popularity, 456.78)
        XCTAssertEqual(movie.posterPath, "/mockdetails.jpg")
        XCTAssertEqual(movie.voteAverage, 7.9)
        XCTAssertEqual(movie.releaseDate, "2024-07-15")
    }
}

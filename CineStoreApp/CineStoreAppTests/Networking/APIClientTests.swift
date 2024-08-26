//
//  APIClientTests.swift
//  CineStoreAppTests
//
//  Created by Guillermo Herrera on 25/08/24.
//

import XCTest
import Alamofire
@testable import CineStoreApp

class APIClientTests: XCTestCase {
    
    var client: APIClient!
    var baseUrl: String!
        
    override func setUp() {
        super.setUp()
        
        // Configure Alamofire to use the mock protocol
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockSession = Session(configuration: configuration)
        
        // Inject the mock session
        client = APIClient(session: mockSession)
        baseUrl = "\(GlobalConfig.MovieDB.apiEndPoint)/\(GlobalConfig.MovieDB.apiVersion)"
    }
    
    override func tearDown() {
        client = nil
        super.tearDown()
    }
    
    func testFetchPopularMoviesSuccess() async throws {
        // Mock JSON response
        let jsonData = """
        {
            "page": 1,
            "results": [
                {
                    "id": 1,
                    "title": "Mock Movie",
                    "genre_ids": [28, 12],
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
        
        // Set the mock response
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://api.themoviedb.org")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, jsonData)
        }
        
        // Perform the request
        let endpoint = "/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc"
        
        do {
            let movieResponse: MovieResponse = try await client.request(endpoint)
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
        } catch {
            XCTFail("Request failed with error: \(error)")
        }
    }
    
    func testFetchPopularMoviesFailure() async throws {
        // Set the mock response with an error
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: self.baseUrl)!,
                                           statusCode: 500,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, nil)
        }
        
        // Perform the request
        let endpoint = "/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc"
        
        do {
            let _: MovieResponse = try await client.request(endpoint)
            XCTFail("Request should have failed")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}

//
//  TheMovieDBAPI.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 25/08/24.
//
import Foundation
import Alamofire

/// Movie DB API. Establis supported network request in use
class MovieDBAPI: MovieDBAPIProtocol {
    private let client: APIClient
        
    init(client: APIClient = APIClient.shared) {
        self.client = client
    }
    
    private func decryptApiKey() -> String {
        let secret = GlobalConfig.MovieDB.secretKey
        let keyData = Array(secret.utf8)
        let decryptedApiKey = CryptoUtil.decrypt(base64EncodedString: GlobalConfig.MovieDB.apiKey, keyData: keyData)
        return decryptedApiKey ?? ""
    }
    
    // Helper method to construct the base URL for movie discovery
    private func constructMovieDiscoveryURL(page: Int, additionalParameters: [String: String]) -> String {
        let decryptedApiKey = decryptApiKey()
        var components = URLComponents(string: "/discover/movie?")!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: decryptedApiKey),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "include_video", value: "false"),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "sort_by", value: "popularity.desc")
        ]
        
        // Append additional parameters specific to each endpoint
        for (key, value) in additionalParameters {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        return components.string!
    }
    
    // Helper method to construct the base URL for movie discovery
    private func constructMovieDedtailURL(movieID: Int, additionalParameters: [String: String]) -> String {
        let decryptedApiKey = decryptApiKey()
        var components = URLComponents(string: "/movie/\(movieID)?")!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: decryptedApiKey),
            URLQueryItem(name: "language", value: "en-US"),
        ]
        
        // Append additional parameters specific to each endpoint
        for (key, value) in additionalParameters {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        return components.string!
    }
    
    // Fetch top-rated movies
    func fetchTopRatedMovies(page: Int = 1) async throws -> MovieResponse {
        let endpoint = constructMovieDiscoveryURL(page: page, additionalParameters: [:])
        return try await client.request(endpoint)
    }
    
    // Fetch now-playing movies with date range
    func fetchNowPlayingMovies(minDate: String, maxDate: String, page: Int = 1) async throws -> MovieResponse {
        let additionalParameters = [
            "with_release_type": "2",
            "release_date.gte": minDate,
            "release_date.lte": maxDate
        ]
        let endpoint = constructMovieDiscoveryURL(page: page, additionalParameters: additionalParameters)
        return try await client.request(endpoint)
    }
    
    // Fetch movie details by ID
    func fetchMovieDetails(movieID: Int) async throws -> Movie {
        let endpoint = constructMovieDedtailURL(movieID: movieID, additionalParameters: [:])
        return try await client.request(endpoint)
    }
}

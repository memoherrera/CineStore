//
//  APIClient.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 25/08/24.
//

import Foundation
import Alamofire

/// General API Client
class APIClient {
    static let shared = APIClient()
    
    private let baseURL = "\(GlobalConfig.MovieDB.apiEndPoint)/\(GlobalConfig.MovieDB.apiVersion)"
    private let session: Session
    
    init(session: Session = Session.default) {
        self.session = session
    }
    
    // Method to get default headers
    func defaultHeaders() -> HTTPHeaders {
        return [
            "accept": "application/json",
        ]
    }
    
    // Generic request method using async/await
    func request<T: Decodable>(_ endpoint: String,
                               method: HTTPMethod = .get,
                               parameters: [String: Any]? = nil,
                               customHeaders: HTTPHeaders? = nil) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        // Use default headers if none are provided
        let headers = customHeaders ?? defaultHeaders()
        
        let data = try await session.request(url, method: method, parameters: parameters, headers: headers)
            .validate()
            .serializingDecodable(T.self).value
        
        return data
    }
}

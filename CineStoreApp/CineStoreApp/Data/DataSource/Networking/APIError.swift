//
//  APIError.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 25/08/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed
}

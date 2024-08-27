//
//  MovieListNavigatorMock.swift
//  CineStoreAppTests
//
//  Created by Guillermo Herrera on 26/08/24.
//

import Foundation
@testable import CineStoreApp

struct MovieListNavigatorMock: MovieListNavigatorProtocol {
    func showError(message: String) {
        // Empty Implemenation. Not required for testing
    }
    
    func toMovieDetail(id: Int) {
        // Empty Implemenation. Not required for testing
    }
    
    
}

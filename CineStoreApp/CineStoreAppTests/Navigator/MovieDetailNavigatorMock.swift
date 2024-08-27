//
//  MovieDetailNavigatorMock.swift
//  CineStoreAppTests
//
//  Created by Guillermo Herrera on 27/08/24.
//

import Foundation
@testable import CineStoreApp

class MockMovieDetailNavigator: MovieDetailNavigatorProtocol {
    var showErrorCalled = false
    var errorMessage: String?
    
    func showError(message: String) {
        showErrorCalled = true
        errorMessage = message
    }
}


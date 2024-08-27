//
//  MovieListNavigatorProtocol.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 26/08/24.
//

import Foundation

protocol MovieListNavigatorProtocol {
    func showError(message: String)
    func toMovieDetail(id: Int)
}

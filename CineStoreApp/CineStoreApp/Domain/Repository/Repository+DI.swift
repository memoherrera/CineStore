//
//  Repsitory+DI.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 25/08/24.
//

import Foundation
import Factory

extension Container {
    var movieRepository: Factory<MovieRepositoryProtocol> {
        Factory(self) { MovieRepository() }
    }
}

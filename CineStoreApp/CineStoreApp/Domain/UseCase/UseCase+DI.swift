//
//  UseCase+DI.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 25/08/24.
//

import Foundation
import Factory

extension Container {
    var movieUseCase: Factory<MovieUseCaseProtocol> {
        Factory(self) { MovieUseCase() }
    }
}

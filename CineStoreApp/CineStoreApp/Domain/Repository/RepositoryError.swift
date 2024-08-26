//
//  RepistoryError.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 25/08/24.
//

import Foundation

enum MovieRepositoryError: Error {
    case deallocatedInstance
    case apiError(Error)
    case unknown
}

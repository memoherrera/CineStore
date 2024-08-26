//
//  ViewModelProtocol.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 26/08/24.
//

import Foundation
import Combine
import Then

protocol ViewModelProtocol: Then {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output
}


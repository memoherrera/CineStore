//
//  ContentDetailProtocol.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 27/08/24.
//

import Foundation

protocol ContentDetailProtocol {
    
    var id: Int { get set }
    var title: String { get set }
    var status: String { get set }
    var releaseDate: String { get set }
    var voteAverage: Double { get set }
    var popularity: Double { get set }
    var body: String { get set }
    var genres: String { get set }
    var languages: String { get set }
    var imagePosterUrl: String { get set }
    var imageBackdropUrl: String { get set }
    
}

struct ContentDetail: ContentDetailProtocol {
    
    var id: Int 
    var title: String 
    var status: String 
    var releaseDate: String
    var voteAverage: Double
    var popularity: Double
    var body: String
    var genres: String 
    var languages: String 
    var imagePosterUrl: String 
    var imageBackdropUrl: String 
    
}

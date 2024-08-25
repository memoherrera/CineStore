//
//  GlobalConfig.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 25/08/24.
//

import Foundation

enum GlobalConfig {
    enum MovieDB {
        
        //TODO: Secure this
        static var apiKey: String {
            return "e361bdcec86ac8696754bb58b56ab9af"
        }
        
        //TODO: Secure this
        static var accessToken: String {
            return "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlMzYxYmRjZWM4NmFjODY5Njc1NGJiNThiNTZhYjlhZiIsIm5iZiI6MTcyNDYwMDY2NS42MDQ0NDksInN1YiI6IjYxZTQ1YzNkMTYyYmMzMDA2NzgxNGVlZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ibPGKpeNBk_vg8xx8rgyjb-7STU15qR69ob9XRCLOr0"
        }

        static var imageUrl: String {
            return "https://image.tmdb.org/t/p/w500"
        }
        
        static var apiEndPoint: String {
            return "https://api.themoviedb.org"
        }

        static var apiVersion: String {
            return "3"
        }
    }
}

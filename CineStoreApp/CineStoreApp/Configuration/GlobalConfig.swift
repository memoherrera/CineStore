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
            return "9bb99f7357dc8b3e3730dee5741dab4f"
        }
        
        //TODO: Secure this
        static var accessToken: String {
            return "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5YmI5OWY3MzU3ZGM4YjNlMzczMGRlZTU3NDFkYWI0ZiIsIm5iZiI6MTcyNDY0NDI1MC44MzA4NzMsInN1YiI6IjYxZTQ1YzNkMTYyYmMzMDA2NzgxNGVlZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.4YxoQ6846yUurCvP1b7V_TzgsZmW-FYFrFhiKD3v5zc"
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

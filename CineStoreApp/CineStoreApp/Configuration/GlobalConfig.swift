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
            return BundleUtil.infoForKey("API_KEY")
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

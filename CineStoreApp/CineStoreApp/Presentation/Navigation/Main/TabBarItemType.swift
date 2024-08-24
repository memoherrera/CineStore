//
//  TabBarItemType.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 24/08/24.
//

import Foundation

import UIKit

enum TabBarItemType: Int {
    case topRated
    case nowPlaying
    case favorites

    static let allValues: [TabBarItemType] = [.topRated, .nowPlaying, .favorites]
}

extension TabBarItemType {
    var image: UIImage? {
        switch self {
        case .topRated:
            return UIImage(systemName: "star.circle")
        case .nowPlaying:
            return UIImage(systemName: "play.circle")
        case .favorites:
            return UIImage(systemName: "heart.circle")
        }
    }

    var selectedImage: UIImage? {
        switch self {
        case .topRated:
            return UIImage(systemName: "star.circle.fill")
        case .nowPlaying:
            return UIImage(systemName: "play.circle.fill")
        case .favorites:
            return UIImage(systemName: "heart.circle.fill")
        }
    }

    var title: String? {
        switch self {
        case .topRated:
            return "Top Rated"
        case .nowPlaying:
            return "Now Playing"
        case .favorites:
            return "Favorites"
        }
    }

    var tabbarItem: UITabBarItem {
        return UITabBarItem(title: title, image: image, selectedImage: selectedImage)
    }
}


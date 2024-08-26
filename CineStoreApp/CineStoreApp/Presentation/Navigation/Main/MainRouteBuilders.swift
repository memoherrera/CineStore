//
//  MainRouteBuilders.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 24/08/24.
//

import Foundation
import LinkNavigator

// MARK: - Top Rated Screen
struct TopRatedScreenBuilder<RootNavigator: MainRootNavigatorType> {
    static func generate() -> RouteBuilderOf<RootNavigator> {
        var matchPath: String { AppRoutes.topRated.rawValue }
        return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
            return WrappingController(matchPath: matchPath, title: "Top Rated") {
                let viewModel = TopRatedMoviesViewModel()
                TopRatedMoviesScreen(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Now Playing Screen
struct NowPlayingScreenBuilder<RootNavigator: MainRootNavigatorType> {
    static func generate() -> RouteBuilderOf<RootNavigator> {
        var matchPath: String { AppRoutes.nowPlaying.rawValue }
        return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
            return WrappingController(matchPath: matchPath, title: "Now Playing") {
                let viewModel = NowPlayingMoviesViewModel()
                NowPlayingMoviesScreen(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Favorites Screen
struct FavoritesScreenBuilder<RootNavigator: MainRootNavigatorType> {
    static func generate() -> RouteBuilderOf<RootNavigator> {
        var matchPath: String { AppRoutes.favorites.rawValue }
        return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
            return WrappingController(matchPath: matchPath, title: "Favorites") {
                FavoriteMoviesScreen()
            }
        }
    }
}


// MARK: - Detail Screen
struct DetailParams: Codable {
    let itemId: Int
}

struct DetailRouteBuilder<RootNavigator: MainRootNavigatorType> {
    static func generate() -> RouteBuilderOf<RootNavigator> {
        var matchPath: String { AppRoutes.detail.rawValue }
        return .init(matchPath: matchPath) { navigator, items, _ -> RouteViewController? in
            return WrappingController(matchPath: matchPath, title: "") {
                
            }
        }
    }
}


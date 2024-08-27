//
//  MainRouteBuilders.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 24/08/24.
//

import Foundation
import LinkNavigator
import Factory

// MARK: - Top Rated Screen
struct TopRatedScreenBuilder<RootNavigator: MainRootNavigatorType> {
    static func generate() -> RouteBuilderOf<RootNavigator> {
        var matchPath: String { AppRoutes.topRated.rawValue }
        return .init(matchPath: matchPath) { navigator, _, _ -> RouteViewController? in
            return WrappingController(matchPath: matchPath, title: "Top Rated") {
                let useCase = Container.shared.movieUseCase.resolve()
                let navigator = MovieListNavigator(navigation: navigator)
                let viewModel = TopRatedMoviesViewModel(navigator: navigator, movieUseCase: useCase)
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
                let useCase = Container.shared.movieUseCase.resolve()
                let navigator = MovieListNavigator(navigation: navigator)
                let viewModel = NowPlayingMoviesViewModel(navigator: navigator, movieUseCase: useCase)
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
                let params: DetailParams = items.decoded() ?? DetailParams(itemId: 0)
                let navigator = MovieDetailNavigator(navigation: navigator)
                let useCase = Container.shared.movieUseCase.resolve()
                let viewModel = MovieDetailViewModel(id: params.itemId, navigator: navigator, movieUseCase: useCase)
                MovieDetailScreen(viewModel: viewModel)
            }
        }
    }
}


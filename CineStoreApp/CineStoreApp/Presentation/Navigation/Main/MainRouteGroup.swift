//
//  MainRouteGroup.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 24/08/24.
//

import Foundation
import LinkNavigator

public typealias MainRootNavigatorType = LinkNavigatorFindLocationUsable & TabLinkNavigatorProtocol

// MARK: - AppMainRouterBuilderGroup

struct MainRouteGroup<RootNavigator: MainRootNavigatorType> {
    init() {}
    
    var routers: [RouteBuilderOf<RootNavigator>] {
        [
            TopRatedScreenBuilder.generate(),
            NowPlayingScreenBuilder.generate(),
            // TODO: FavoritesScreenBuilder.generate(),
            DetailRouteBuilder.generate()
        ]
    }
}


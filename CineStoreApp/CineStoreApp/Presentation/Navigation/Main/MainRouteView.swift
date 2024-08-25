//
//  HomeRoute.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 24/08/24.
//

import SwiftUI
import LinkNavigator

struct MainRouteView: View {
    var body: some View {
        mainRoute()
    }
    
    // MARK: - Main
    private let tabLinkNavigator = TabLinkNavigator(
        routeBuilderItemList: MainRouteGroup().routers,
        dependency: NavigatorDependency())

    private let tabItems: [TabItem] = [
        .init(
            tag: TabBarItemType.topRated.rawValue,
            tabItem: TabBarItemType.topRated.tabbarItem,
            linkItem: .init(path: AppRoutes.topRated.rawValue)),
        .init(
            tag: TabBarItemType.nowPlaying.rawValue,
            tabItem: TabBarItemType.nowPlaying.tabbarItem,
            linkItem: .init(path: AppRoutes.nowPlaying.rawValue)),
        .init(
            tag: TabBarItemType.favorites.rawValue,
            tabItem: TabBarItemType.favorites.tabbarItem,
            linkItem: .init(path: AppRoutes.favorites.rawValue))
    ]

    @ViewBuilder
    func mainRoute() -> some View {
        TabLinkNavigationView(
            linkNavigator: tabLinkNavigator,
            isHiddenDefaultTabbar: false,
            tabItemList: tabItems,
            isAnimatedForUpdateTabbar: false
        ).background(Color(UIColor.backgroundPrimary))
    }
}

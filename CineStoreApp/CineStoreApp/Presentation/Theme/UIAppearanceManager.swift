//
//  UIAppearanceManager.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 24/08/24.
//

import Foundation
import UIKit
import Then

struct UIAppearanceManager {
    static func configure(navigationBar: UINavigationBar = UINavigationBar.appearance(), tabBar: UITabBar = UITabBar.appearance()) {
            configureNavigationBar(navigationBar: navigationBar)
            configureTabBar(tabBar: tabBar)
    }
        
    static func configureNavigationBar(navigationBar: UINavigationBar) {
        navigationBar.do {
            $0.isTranslucent = false
            $0.tintColor = UIColor.accent
        }

        let appearance = UINavigationBarAppearance().with {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = UIColor.backgroundPrimary
            $0.shadowColor = .clear
            $0.shadowImage = UIImage()
            $0.titleTextAttributes = [.foregroundColor: UIColor.accent]
        }
        navigationBar.do {
            $0.standardAppearance = appearance
            $0.scrollEdgeAppearance = appearance
        }
    }
    
    static func configureTabBar(tabBar: UITabBar) {
        tabBar.do {
            $0.tintColor = UIColor.accent
            $0.barTintColor = .black
            $0.unselectedItemTintColor = UIColor.systemGray
            $0.isTranslucent = false
        }

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.backgroundPrimary
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

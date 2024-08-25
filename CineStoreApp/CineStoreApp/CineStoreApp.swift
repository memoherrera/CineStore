//
//  CineStoreAppApp.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 24/08/24.
//

import SwiftUI
import SwiftData

@main
/// Application Entry Point
struct CineStoreApp: App {
    init() {
        UIAppearanceManager.configure()
    }

    var body: some Scene {
        MainScene()
    }
}

//
//  TopRatedMoviesScreens.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 24/08/24.
//

import SwiftUI

struct TopRatedMoviesScreen: View {
    @State var isLoading: Bool = false
    var body: some View {
        BaseContentView(isLoading: $isLoading, title: "Top Rated") {
            ScrollView(showsIndicators: false) {
                
            }
        }
    }
}

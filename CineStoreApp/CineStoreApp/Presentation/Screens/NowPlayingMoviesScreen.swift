//
//  NowPlayingMoviesScreen.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 24/08/24.
//

import SwiftUI

struct NowPlayingMoviesScreen: View {
    @State var isLoading: Bool = false
    var body: some View {
        BaseContentView(isLoading: $isLoading, title: "Now Playing") {
            ScrollView(showsIndicators: false) {
                
            }
        }
    }
}

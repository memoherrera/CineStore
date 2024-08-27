//
//  NowPlayingMoviesScreen.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 24/08/24.
//

import SwiftUI

struct NowPlayingMoviesScreen: View {
    @State var isLoading: Bool = false
    @State var scrollPosition: Int? = nil
    var input: NowPlayingMoviesViewModel.Input
    @ObservedObject var output: NowPlayingMoviesViewModel.Output
    
    private let cancelBag = CancelBag()
    private let toDetailTrigger = NeverFailingPassthroughSubject<Int>()
    private let loadTrigger = NeverFailingPassthroughSubject<Bool>()
    private var loadNextPageTrigger = NeverFailingPassthroughSubject<Bool>()
    
    @ViewBuilder
    func nowPlayingMovies() -> some View {
        LazyVStack {
            ForEach(output.data.items) { listItem in
                Button {
                    toDetailTrigger.send(listItem.id)
                } label: {
                    VerticalImageCard(listItem: listItem)
                }
                .tint(.black)
            }
            if output.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.accentColor))
                    .scaleEffect(1.25, anchor: .center)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }.scrollTargetLayout()
    }
    
    var body: some View {
        BaseContentView(isLoading: $isLoading, title: "Now Paying") {
            ScrollView(showsIndicators: false) {
                nowPlayingMovies()
            }
            .padding(16)
            .refreshable {
                loadTrigger.send(true)
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollBounceBehavior(.basedOnSize)
            .scrollPosition(id: $scrollPosition, anchor: .center)
            .contentMargins(.bottom, 120, for: .scrollContent)
        }.onChange(of: scrollPosition) {
            let lastElementId = output.data.items.last?.id
            if (lastElementId == scrollPosition) {
                loadNextPageTrigger.send(true)
            }
        }
        
    }
    
    init(viewModel: NowPlayingMoviesViewModel) {
        let input = NowPlayingMoviesViewModel.Input(
            loadTrigger: loadTrigger.asNeverFailing(),
            loadNextPageTrigger: loadNextPageTrigger.asNeverFailing(),
            toDetailTrigger: toDetailTrigger.asNeverFailing())
        output = viewModel.transform(input, cancelBag: cancelBag)
        self.input = input
    }
}

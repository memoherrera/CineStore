//
//  TopRatedMoviesScreens.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 24/08/24.
//

import SwiftUI

struct TopRatedMoviesScreen: View {
    @State var isLoading: Bool = false
    var input: TopRatedMoviesViewModel.Input
    @ObservedObject var output: TopRatedMoviesViewModel.Output
    
    private let cancelBag = CancelBag()
    private let toDetailTrigger = NeverFailingPassthroughSubject<Int>()
    private let loadTrigger = NeverFailingPassthroughSubject<Bool>()
    
    @ViewBuilder
    func topRatedMovies() -> some View {
        Section() {
            ForEach(output.data.items) { listItem in
                Button {
                    toDetailTrigger.send(listItem.id)
                } label: {
                    VerticalImageCard(listItem: listItem)
                }
                .tint(.black)
            }
        }
    }
    
    var body: some View {
        BaseContentView(isLoading: $isLoading, title: "Top Rated") {
            ScrollView(showsIndicators: false) {
                topRatedMovies()
            }
            .padding(16)
            .refreshable {
                loadTrigger.send(true)
            }
        }
        .onAppear {
            loadTrigger.send(false)
        }
        
    }
    
    init(viewModel: TopRatedMoviesViewModel) {
        let input = TopRatedMoviesViewModel.Input(loadTrigger: loadTrigger.asNeverFailing(),
                                             toDetailTrigger: toDetailTrigger.asNeverFailing())
        output = viewModel.transform(input, cancelBag: cancelBag)
        self.input = input
    }
}

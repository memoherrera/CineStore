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
    @State private var isGridLayout: Bool = false
    var input: NowPlayingMoviesViewModel.Input
    @ObservedObject var output: NowPlayingMoviesViewModel.Output
    
    private let cancelBag = CancelBag()
    private let toDetailTrigger = NeverFailingPassthroughSubject<Int>()
    private let loadTrigger = NeverFailingPassthroughSubject<Bool>()
    private var loadNextPageTrigger = NeverFailingPassthroughSubject<Bool>()
    
    var toggleButton: some View {
        Button(action: {
            isGridLayout.toggle()
        }) {
            Image(systemName: isGridLayout ? "list.bullet" : "square.grid.2x2" )
                .font(.title2)
        }
    }
    
    @ViewBuilder
    func listLayout() -> some View {
        LazyVStack {
            ForEach(output.data.items) { listItem in
                Button {
                    toDetailTrigger.send(listItem.id)
                } label: {
                    VerticalImageCard(listItem: listItem, showDetails: true)
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
            if (!output.isLoading && output.data.items.count == 0) {
                NoContentView {
                    loadTrigger.send(true)
                }
            }
        }.scrollTargetLayout()
    }
    
    // Grid layout with 2 columns
    @ViewBuilder
    func gridLayout() -> some View {
        LazyVStack {
            ForEach(0..<output.data.items.count, id: \.self) { index in
                if index % 2 == 0 {
                    HStack(spacing: 8) {
                        // First item
                        Button {
                            toDetailTrigger.send(output.data.items[index].id)
                        } label: {
                            VerticalImageCard(listItem: output.data.items[index], showDetails: false)
                        }
                        .tint(.black)

                        // Second item (if exists)
                        if index + 1 < output.data.items.count {
                            Button {
                                toDetailTrigger.send(output.data.items[index + 1].id)
                            } label: {
                                VerticalImageCard(listItem: output.data.items[index + 1], showDetails: false)
                            }
                            .tint(.black)
                        } else {
                            // Spacer to keep the alignment
                            Spacer()
                        }
                    }
                }
            }
        }
        .scrollTargetLayout()
    }
    
    var body: some View {
        BaseContentView(isLoading: $isLoading, title: "Now Paying") {
            ScrollView(showsIndicators: false) {
                if isGridLayout {
                    gridLayout()
                } else {
                    listLayout()
                }
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
            let indexToTriggerNextPage = output.data.items.endIndex - 4 // prev last row
            if (scrollPosition == lastElementId || scrollPosition == indexToTriggerNextPage) {
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

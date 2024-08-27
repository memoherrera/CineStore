//
//  TopRatedMoviesViewModel.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 26/08/24.
//

import Foundation
import Factory
import Combine

class TopRatedMoviesViewModel: ViewModelProtocol {
    let navigator: MovieListNavigatorProtocol
    let movieUseCase: MovieUseCaseProtocol
    
    public init(navigator: MovieListNavigatorProtocol, movieUseCase: MovieUseCaseProtocol) {
        self.navigator = navigator
        self.movieUseCase = movieUseCase
    }
    
    struct Page {
        var items: [ListItem] = []
        var currentPage: Int = 1
        var totalPages: Int = 1
    }
    
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var isLoadingPage = false
    
    struct Input {
        let loadTrigger: NeverFailingPublisher<Bool>
        let loadNextPageTrigger: NeverFailingPublisher<Bool>
        let toDetailTrigger: NeverFailingPublisher<Int>
    }

    final class Output: ObservableObject {
        @Published var isLoading = false
        @Published var isReloading = false
        @Published var data = Page()
    }
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityTracker()
        let reloadActivityTracker = ActivityTracker()
        let output = Output()
        
        activityTracker.isLoading
            .receive(on: RunLoop.main)
            .assign(to: \.isLoading, on: output)
            .cancel(with: cancelBag)

        reloadActivityTracker.isLoading
            .receive(on: RunLoop.main)
            .assign(to: \.isReloading, on: output)
            .cancel(with: cancelBag)


        input.loadTrigger
            .map { isReload in
                self.movieUseCase.getTopRatedMovies(page: 1)
                    .trackActivity(isReload ? reloadActivityTracker : activityTracker)
                    .trackError(errorTracker)
                    .asNeverFailing()
            }
            .switchToLatest()
            .map { movieResponse in
                self.totalPages = movieResponse.totalPages
                let listItems = movieResponse.results.map { $0.toListItem() }
                var page = Page()
                page.items = listItems
                page.currentPage = 1
                return page
            }
            .assign(to: \.data, on: output)
            .cancel(with: cancelBag)
        
        input.loadNextPageTrigger
            .filter { _ in !self.isLoadingPage && self.currentPage < self.totalPages }
            .map { _ in
                self.isLoadingPage = true
                self.currentPage += 1
                return self.movieUseCase.getTopRatedMovies(page: self.currentPage)
                    .trackActivity(activityTracker)
                    .trackError(errorTracker)
                    .asNeverFailing()
            }
            .switchToLatest()
            .map { movieResponse in
                self.isLoadingPage = false
                var currentItems = output.data.items
                let listItems = movieResponse.results.map { $0.toListItem() }
                currentItems.append(contentsOf: listItems)
                return Page(items: currentItems, currentPage: self.currentPage, totalPages: self.totalPages)
            }
            .assign(to: \.data, on: output)
            .cancel(with: cancelBag)

        errorTracker
            .receive(on: RunLoop.main)
            .unwrap()
            .sink(receiveValue: { error in
                self.navigator.showError(message: error.localizedDescription)
            })
            .cancel(with: cancelBag)
        
        input.toDetailTrigger
            .sink(receiveValue: navigator.toMovieDetail(id:))
            .cancel(with: cancelBag)

        return output
    }

}

//
//  NowPlayingViewModel.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 26/08/24.
//

import Foundation
import Factory
import Combine

class NowPlayingMoviesViewModel: ViewModelProtocol {
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
        
        // Load
        Just(true).map { _ in
                let now = Date().toFormattedString()
                return self.movieUseCase.getNowPlayingMovies(minDate: now, maxDate: now, page: 1)
                    .trackError(errorTracker)
                    .trackActivity(activityTracker)
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
        
        // Reload
       input.loadTrigger
            .map { isReload in
                let now = Date().toFormattedString()
                return self.movieUseCase.getNowPlayingMovies(minDate: now, maxDate: now, page: 1)
                    .trackError(errorTracker)
                    .trackActivity(isReload ? reloadActivityTracker : activityTracker)
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
        
        // Next Page
        input.loadNextPageTrigger
            .filter { _ in !self.isLoadingPage && self.currentPage < self.totalPages }
            .map { _ in
                self.isLoadingPage = true
                self.currentPage += 1
                let now = Date().toFormattedString()
                return self.movieUseCase.getNowPlayingMovies(minDate: now, maxDate: now, page: self.currentPage)
                    .trackError(errorTracker)
                    .trackActivity(activityTracker)
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


        activityTracker.isLoading
            .receive(on: RunLoop.main)
            .assign(to: \.isLoading, on: output)
            .cancel(with: cancelBag)

        reloadActivityTracker.isLoading
            .receive(on: RunLoop.main)
            .assign(to: \.isReloading, on: output)
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


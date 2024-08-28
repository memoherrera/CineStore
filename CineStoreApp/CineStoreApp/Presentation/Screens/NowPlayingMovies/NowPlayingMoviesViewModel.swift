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

        setupLoadingIndicators(output: output, activityTracker: activityTracker, reloadActivityTracker: reloadActivityTracker, cancelBag: cancelBag)
        setupErrorHandling(errorTracker: errorTracker, cancelBag: cancelBag)

        // Initial Load
        performLoad(isReload: false, output: output, activityTracker: activityTracker, errorTracker: errorTracker, cancelBag: cancelBag)

        // Load on Trigger
        input.loadTrigger
            .sink { isReload in
                self.performLoad(isReload: isReload, output: output, activityTracker: isReload ? reloadActivityTracker : activityTracker, errorTracker: errorTracker, cancelBag: cancelBag)
            }
            .cancel(with: cancelBag)

        // Load Next Page
        input.loadNextPageTrigger
            .filter { _ in !self.isLoadingPage && self.currentPage < self.totalPages }
            .sink { _ in
                self.performLoadNextPage(output: output, activityTracker: activityTracker, errorTracker: errorTracker, cancelBag: cancelBag)
            }
            .cancel(with: cancelBag)

        // Navigation
        input.toDetailTrigger
            .sink(receiveValue: navigator.toMovieDetail(id:))
            .cancel(with: cancelBag)

        return output
    }
    
    private func setupLoadingIndicators(output: Output, activityTracker: ActivityTracker, reloadActivityTracker: ActivityTracker, cancelBag: CancelBag) {
        activityTracker.isLoading
            .receive(on: RunLoop.main)
            .assign(to: \.isLoading, on: output)
            .cancel(with: cancelBag)

        reloadActivityTracker.isLoading
            .receive(on: RunLoop.main)
            .assign(to: \.isReloading, on: output)
            .cancel(with: cancelBag)
    }

    private func setupErrorHandling(errorTracker: ErrorTracker, cancelBag: CancelBag) {
        errorTracker
            .receive(on: RunLoop.main)
            .unwrap()
            .sink(receiveValue: { error in
                self.navigator.showError(message: error.localizedDescription)
            })
            .cancel(with: cancelBag)
    }

    private func performLoad(isReload: Bool, output: Output, activityTracker: ActivityTracker, errorTracker: ErrorTracker, cancelBag: CancelBag) {
        let now = Date().toFormattedString()
        movieUseCase.getNowPlayingMovies(minDate: now, maxDate: now, page: 1)
            .trackActivity(activityTracker)
            .trackError(errorTracker)
            .asNeverFailing()
            .map { movieResponse in
                self.currentPage = 1
                self.totalPages = movieResponse.totalPages
                let listItems = movieResponse.results.map { $0.toListItem() }
                return Page(items: listItems, currentPage: self.currentPage, totalPages: self.totalPages)
            }
            .receive(on: RunLoop.main)
            .assign(to: \.data, on: output)
            .cancel(with: cancelBag)
    }

    private func performLoadNextPage(output: Output, activityTracker: ActivityTracker, errorTracker: ErrorTracker, cancelBag: CancelBag) {
        isLoadingPage = true
        currentPage += 1
        let now = Date().toFormattedString()
        movieUseCase.getNowPlayingMovies(minDate: now, maxDate: now, page: currentPage)
            .trackActivity(activityTracker)
            .trackError(errorTracker)
            .asNeverFailing()
            .map { movieResponse in
                self.isLoadingPage = false
                self.totalPages = movieResponse.totalPages
                var currentItems = output.data.items
                let listItems = movieResponse.results.map { $0.toListItem() }
                currentItems.append(contentsOf: listItems)
                return Page(items: currentItems, currentPage: self.currentPage, totalPages: self.totalPages)
            }
            .receive(on: RunLoop.main)
            .assign(to: \.data, on: output)
            .cancel(with: cancelBag)
    }
}


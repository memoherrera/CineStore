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
    
    @Injected(\.movieUseCase) private var movieUseCase
    
    struct Page {
        var items: [ListItem] = []
        var currentPage: Int = 1
    }
    
    struct Input {
        let loadTrigger: NeverFailingPublisher<Bool>
        let toDetailTrigger: NeverFailingPublisher<Int>
    }

    final class Output: ObservableObject {
        @Published var isLoading = false
        @Published var isReloading = false
        @Published var data = Page()
    }
    
    func getDateFormated() -> String {
        return ""
    }
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityTracker()
        let reloadActivityTracker = ActivityTracker()
        let output = Output()

       input.loadTrigger
            .map { isReload in
                let now = Date().toFormattedString()
                return self.movieUseCase.getNowPlayingMovies(minDate: now, maxDate: now, page: 1)
                    .trackError(errorTracker)
                    .trackActivity(isReload ? reloadActivityTracker : activityTracker)
                    .asNeverFailing()
            }
            .switchToLatest()
            .map { movies in
                movies.map { $0.toListItem() }
            }.map { listItems in
                var page = Page()
                page.items = listItems
                page.currentPage = 1
                return page
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
                // TODO: Show error
                print(error)
            })
            .cancel(with: cancelBag)

        return output
    }

}


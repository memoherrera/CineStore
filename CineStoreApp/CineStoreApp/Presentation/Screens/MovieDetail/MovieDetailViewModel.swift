//
//  MovieDetailViewModel.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 26/08/24.
//
import Combine
import Factory
import Foundation

class MovieDetailViewModel: ViewModelProtocol {
    let id: Int
    let navigator: MovieDetailNavigatorProtocol
    var movieUseCase: MovieUseCaseProtocol
    
    init(id: Int, navigator: MovieDetailNavigatorProtocol, movieUseCase: MovieUseCaseProtocol) {
        self.id = id
        self.navigator = navigator
        self.movieUseCase = movieUseCase
    }

    struct Input {
        let loadTrigger: NeverFailingPublisher<Bool>
    }

    final class Output: ObservableObject {
        @Published var isLoading = false
        @Published var isReloading = false
        @Published var contentDetail: ContentDetail?
        @Published var hasError = false
    }

    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        let activityTracker = ActivityTracker()
        let reloadActivityTracker = ActivityTracker()
        let errorTracker = ErrorTracker()

        input.loadTrigger
            .map { isReload in
                return self.movieUseCase.getMovieDetail(id: self.id)
                    .trackError(errorTracker)
                    .trackActivity(isReload ? reloadActivityTracker : activityTracker)
                    .asNeverFailing()
            }
            .switchToLatest()
            .map { $0?.toContentDetail() }
            .assign(to: \.contentDetail, on: output)
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
                output.hasError = true
                self.navigator.showError(message: error.localizedDescription)
            })
            .cancel(with: cancelBag)
                    
        output.$contentDetail
                .compactMap { $0 }
                .sink { _ in
                    output.hasError = false
                }
                .cancel(with: cancelBag)

        return output
    }
}


//
//  TopRatedMoviesViewModelTests.swift
//  CineStoreAppTests
//
//  Created by Guillermo Herrera on 26/08/24.
//

import XCTest
import Combine
import Factory
@testable import CineStoreApp

class TopRatedMoviesViewModelTests: XCTestCase {
    var viewModel: TopRatedMoviesViewModel!
    var mockUseCase: MockMovieUseCase!
    var cancelBag: CancelBag!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancelBag = CancelBag()
        cancellables = []
        
        // Inject the mock use case
        mockUseCase = MockMovieUseCase()
        Container.shared.movieUseCase.register { self.mockUseCase }
        let useCase = Container.shared.movieUseCase.resolve()
        let mockNavigator = MovieListNavigatorMock()
        viewModel = TopRatedMoviesViewModel(navigator: mockNavigator, movieUseCase: useCase)
    }
    
    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        cancelBag = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testLoadTopRatedMoviesSuccess() {
        // Given
        let expectedMovies = [
            Movie(id: 1, title: "Mock Movie 1", genreIds: [28], overview: "Overview 1", popularity: 1000, posterPath: "/path1.jpg", voteAverage: 8.0,  releaseDate: "2024-01-01"),
            Movie(id: 2, title: "Mock Movie 2", genreIds: [12], overview: "Overview 2", popularity: 900, posterPath: "/path2.jpg", voteAverage: 7.5, releaseDate: "2024-02-01")
        ]
        mockUseCase.topRatedMoviesResult = .success(MovieResponse(page: 1, results: expectedMovies, totalPages: 1, totalResults: 2))
       
        // Create inputs
        let loadTrigger = PassthroughSubject<Bool, Never>()
        let loadNextPageTrigger = PassthroughSubject<Bool, Never>()
        let toDetailTrigger = PassthroughSubject<Int, Never>()
        let input = TopRatedMoviesViewModel.Input(loadTrigger: loadTrigger.eraseToAnyPublisher(), 
                                                  loadNextPageTrigger: loadNextPageTrigger.eraseToAnyPublisher(),
                                                  toDetailTrigger: toDetailTrigger.eraseToAnyPublisher())
       
        // When
        let output = viewModel.transform(input, cancelBag: cancelBag)
           
        let expectation = XCTestExpectation(description: "Should load top-rated movies")
           
        // Observe changes in the output's data property
        output.$data
            .dropFirst() // Skip the initial value
            .sink { page in
                // Then
                XCTAssertEqual(page.items.count, expectedMovies.count)
                XCTAssertEqual(page.items.first?.title, "Mock Movie 1")
                XCTAssertEqual(page.items.last?.title, "Mock Movie 2")
                expectation.fulfill()
            }
            .store(in: &cancellables)
           
        // Trigger the load
        loadTrigger.send(true)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLoadTopRatedMoviesFailure() {
        // Given
        let expectedError = MovieRepositoryError.apiError(NSError(domain: "", code: -1, userInfo: nil))
        mockUseCase.topRatedMoviesResult = .failure(expectedError)
        
        // Create inputs
        let loadTrigger = Just(true).setFailureType(to: Never.self).eraseToAnyPublisher()
        let loadNextPageTrigger = PassthroughSubject<Bool, Never>()
        let toDetailTrigger = PassthroughSubject<Int, Never>()
        let input = TopRatedMoviesViewModel.Input(loadTrigger: loadTrigger, 
                                                  loadNextPageTrigger: loadNextPageTrigger.eraseToAnyPublisher(),
                                                  toDetailTrigger: toDetailTrigger.eraseToAnyPublisher())
        
        // When
        let output = viewModel.transform(input, cancelBag: cancelBag)
        
        // Then
        XCTAssertEqual(output.data.items.count, 0)
    }
}

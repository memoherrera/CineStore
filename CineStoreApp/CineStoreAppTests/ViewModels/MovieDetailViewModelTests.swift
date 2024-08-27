//
//  MovieDetailViewModelTests.swift
//  CineStoreAppTests
//
//  Created by Guillermo Herrera on 27/08/24.
//

import XCTest
import Combine
@testable import CineStoreApp // Replace with your project's module name

class MovieDetailViewModelTests: XCTestCase {
    var viewModel: MovieDetailViewModel!
    var mockUseCase: MockMovieUseCase!
    var mockNavigator: MockMovieDetailNavigator!
    var cancelBag: CancelBag!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockMovieUseCase()
        mockNavigator = MockMovieDetailNavigator()
        cancelBag = CancelBag()
        cancellables = []
        
        viewModel = MovieDetailViewModel(
            id: 1,
            navigator: mockNavigator,
            movieUseCase: mockUseCase
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        mockNavigator = nil
        cancelBag = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testLoadMovieDetailSuccess() {
        // Given
        let expectedMovie = Movie(
            id: 1,
            title: "Test Movie",
            genreIds: [18, 28],
            overview: "This is a test movie overview.",
            popularity: 123.45,
            posterPath: "/testposter.jpg",
            voteAverage: 8.7,
            releaseDate: "2024-01-01"
        )
        mockUseCase.getMovieDetailResult = .success(expectedMovie)
        
        let loadTrigger = PassthroughSubject<Bool, Never>()
        let input = MovieDetailViewModel.Input(loadTrigger: loadTrigger.eraseToAnyPublisher())
        let output = viewModel.transform(input, cancelBag: cancelBag)
        
        let expectation = XCTestExpectation(description: "Should load movie detail successfully")
        
        // Observe output changes
        output.$movie
            .compactMap { $0 } // Ignore nil values
            .sink { movie in
                XCTAssertEqual(movie.id, expectedMovie.id)
                XCTAssertEqual(movie.title, expectedMovie.title)
                XCTAssertEqual(movie.genres, expectedMovie.genres)
                XCTAssertEqual(movie.overview, expectedMovie.overview)
                XCTAssertEqual(movie.popularity, expectedMovie.popularity)
                XCTAssertEqual(movie.posterPath, expectedMovie.posterPath)
                XCTAssertEqual(movie.voteAverage, expectedMovie.voteAverage)
                XCTAssertEqual(movie.releaseDate, expectedMovie.releaseDate)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Observe loading states
        var isLoadingStates: [Bool] = []
        output.$isLoading
            .sink { isLoading in
                isLoadingStates.append(isLoading)
            }
            .store(in: &cancellables)
        
        // When
        loadTrigger.send(false) // Not a reload
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        
        // Verify loading states [initial, first false observed, loading, finished]
        XCTAssertEqual(isLoadingStates, [false, false, true, false])
        
        // Verify navigator was not called
        XCTAssertFalse(mockNavigator.showErrorCalled)
    }
    
    func testLoadMovieDetailFailure() {
        // Given
        let expectedError = NSError(domain: "TestErrorDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "Movie not found"])
        mockUseCase.getMovieDetailResult = .failure(expectedError)
        
        let loadTrigger = PassthroughSubject<Bool, Never>()
        let input = MovieDetailViewModel.Input(loadTrigger: loadTrigger.eraseToAnyPublisher())
        let output = viewModel.transform(input, cancelBag: cancelBag)
        
        let expectation = XCTestExpectation(description: "Should handle movie detail loading failure")
        
        // Observe output changes
        output.$movie
            .sink { movie in
                XCTAssertNil(movie)
            }
            .store(in: &cancellables)
        
        // Observe loading states
        var isLoadingStates: [Bool] = []
        output.$isLoading
            .sink { isLoading in
                isLoadingStates.append(isLoading)
            }
            .store(in: &cancellables)
        
        // Delay to allow error handling
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        // When
        loadTrigger.send(false)
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        
        // Verify loading states [initial, first false observed, loading, finished]
        XCTAssertEqual(isLoadingStates, [false, false, true, false])
        
        // Verify navigator was called with correct error message
        XCTAssertTrue(mockNavigator.showErrorCalled)
        XCTAssertEqual(mockNavigator.errorMessage, "Movie not found")
    }
}


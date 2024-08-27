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
            genres: [Genre(id: 18, name: "Action"), Genre(id: 28, name: "Drama")],
            overview: "This is a test movie overview.",
            popularity: 123.45,
            posterPath: "/testposter.jpg",
            backdropPath: "/testBackdrop.jpg",
            voteAverage: 8.7,
            releaseDate: "2024-01-01"
        )
        mockUseCase.getMovieDetailResult = .success(expectedMovie)
        
        let loadTrigger = PassthroughSubject<Bool, Never>()
        let input = MovieDetailViewModel.Input(loadTrigger: loadTrigger.eraseToAnyPublisher())
        let output = viewModel.transform(input, cancelBag: cancelBag)
        
        let expectation = XCTestExpectation(description: "Should load movie detail successfully")
        
        // Observe output changes
        output.$contentDetail
           .compactMap { $0 } // Ignore nil values
           .sink { contentDetail in
               XCTAssertEqual(contentDetail.id, expectedMovie.id)
               XCTAssertEqual(contentDetail.title, expectedMovie.title)
               XCTAssertEqual(contentDetail.status, expectedMovie.status)
               XCTAssertEqual(contentDetail.releaseDate, expectedMovie.releaseDate)
               XCTAssertEqual(contentDetail.voteAverage, expectedMovie.voteAverage)
               XCTAssertEqual(contentDetail.popularity, expectedMovie.popularity)
               XCTAssertEqual(contentDetail.body, expectedMovie.overview)
               XCTAssertEqual(contentDetail.genres, expectedMovie.fullGenresString())
               XCTAssertEqual(contentDetail.languages, expectedMovie.fullLanguagesString())
               XCTAssertEqual(contentDetail.imagePosterUrl, expectedMovie.posterUrl)
               XCTAssertEqual(contentDetail.imageBackdropUrl, expectedMovie.backdropUrl)
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
        output.$contentDetail
            .sink { detail in
                XCTAssertNil(detail)
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


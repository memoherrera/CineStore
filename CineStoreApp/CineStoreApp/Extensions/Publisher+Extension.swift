//
//  Publisher+Extension.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 25/08/24.
//

import Combine
import Foundation

/// In order to create binding between outputs and obvsered published properties
public typealias NeverFailingPublisher<T> = AnyPublisher<T, Never>
public typealias NeverFailingPassthroughSubject<T> = PassthroughSubject<T, Never>
public typealias NeverFailingCurrentValueSubject<T> = CurrentValueSubject<T, Never>
public typealias ErrorTracker = PassthroughSubject<Error?, Never>

// MARK: - NeverFailing
extension Publisher {
    public func asNeverFailing() -> NeverFailingPublisher<Output> {
        return self.catch { _ in Empty() }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    public static func just(_ output: Output) -> NeverFailingPublisher<Output> {
        return Just(output).eraseToAnyPublisher()
    }

    public static func empty() -> NeverFailingPublisher<Output> {
        return Empty().eraseToAnyPublisher()
    }
}

extension Publisher where Failure: Error {
    public func trackError(_ errorTracker: ErrorTracker) -> AnyPublisher<Output, Failure> {
        return handleEvents(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                errorTracker.send(error)
            }
        })
        .eraseToAnyPublisher()
    }
}

extension Publisher where Output: OptionalType {
    func unwrap() -> Unwrapped<Self> {
        return Unwrapped(upstream: self)
    }
}


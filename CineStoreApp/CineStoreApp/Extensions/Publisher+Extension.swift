//
//  Publisher+Extension.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 25/08/24.
//

import Combine
import Foundation

public typealias NeverFailingPublisher<T> = AnyPublisher<T, Never>
public typealias NeverFailingPassthroughSubject<T> = PassthroughSubject<T, Never>

// MARK: - NeverFailing
extension NeverFailingPublisher {
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

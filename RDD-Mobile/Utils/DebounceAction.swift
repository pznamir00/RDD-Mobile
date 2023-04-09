//
//  DebounceAction.swift
//  RDD-Mobile
//
//  Created by Patryk Znamirowski on 09/04/2023.
//

import Foundation
import Combine


class DebounceAction<T> {
    private let publisher = PassthroughSubject<T, Never>()
    private var subscription = Set<AnyCancellable>()
    
    init(_ debounceTime: CGFloat, callback: @escaping (_: T) -> Void) {
        self.publisher
            .throttle(
                for: .seconds(debounceTime),
                scheduler: RunLoop.main,
                latest: true
            )
            .sink { callback($0) }
            .store(in: &self.subscription)
    }
    
    func emit(value: T) {
        self.publisher.send(value)
    }
    
//    deinit() {
//
//    }
}

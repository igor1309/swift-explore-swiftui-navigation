//
//  AnyPublisher+ext.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import Foundation

#if DEBUG
import Combine

public extension AnyPublisher where Output == [Completion], Failure == Never {
    
    static let prevSearches: Self = Just(.prevSearches).eraseToAnyPublisher()
    static let preview: Self = Just(.preview).eraseToAnyPublisher()
}

public extension AnyPublisher where Output == Address?, Failure == Never {
    
    static let null: Self = Just(nil).eraseToAnyPublisher()
    static let preview: Self = Just(.preview).eraseToAnyPublisher()
}

public extension AnyPublisher where Output == [Address], Failure == Never {
    
    static let empty: Self = Just([]).eraseToAnyPublisher()
    static let preview: Self = Just(.preview).eraseToAnyPublisher()
}
#endif

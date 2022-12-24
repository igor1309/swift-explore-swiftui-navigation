//
//  AnyPublisher+ext.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import Foundation

#if DEBUG
import Combine

public extension AnyPublisher where Output == [Suggestion], Failure == Never {
    
    static let prevSearches: Self = Just(.prevSearches).eraseToAnyPublisher()
    static let preview: Self = Just(.preview).eraseToAnyPublisher()
}
#endif

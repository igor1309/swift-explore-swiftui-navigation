//
//  AddressPublisher+preview.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import CasePaths
import Combine
import Foundation
import MapDomain

#if DEBUG
extension CoordinateSearch.AddressResultPublisher {
    
    static func preview(coordinate: LocationCoordinate2D) -> Self {
        Just(.success(Address.preview))
            .eraseToAnyPublisher()
    }
    static func delayedPreview(coordinate: LocationCoordinate2D) -> Self {
        Just(.success(Address.preview))
            .delay(for: 1, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    static func failing(coordinate: LocationCoordinate2D) -> Self {
        Just(.failure(NSError(domain: "failing publisher", code: 0)))
            .delay(for: 0.5, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
#endif

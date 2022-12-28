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
extension AddressMapSearchViewModel.AddressPublisher {
    
    static func preview(coordinate: LocationCoordinate2D) -> Self {
        Just(Address.preview)
            .map(/Optional.some)
            .eraseToAnyPublisher()
    }
    static func delayedPreview(coordinate: LocationCoordinate2D) -> Self {
        Just(Address.preview)
            .delay(for: 1, scheduler: DispatchQueue.main)
            .map(/Optional.some)
            .eraseToAnyPublisher()
    }
    static func failing(coordinate: LocationCoordinate2D) -> Self {
        Just(Address?.none)
            .delay(for: 0.5, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
#endif

//
//  AddressPublisher+ext.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import CasePaths
import Combine
import MapDomain

#if DEBUG
extension AddressMapSearchViewModel.AddressPublisher {
    
    static func preview(coordinate: LocationCoordinate2D) -> Self {
        Just(Address.preview).map(/Optional.some).eraseToAnyPublisher()
    }
}
#endif

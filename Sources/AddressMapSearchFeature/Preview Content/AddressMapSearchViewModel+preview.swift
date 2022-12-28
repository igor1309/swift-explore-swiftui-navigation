//
//  AddressMapSearchViewModel+preview.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import MapDomain

#if DEBUG
public extension AddressMapSearchViewModel {
    
    static func preview(
        _ initialRegion: CoordinateRegion = .townLondon
    ) -> AddressMapSearchViewModel {
        .init(
            initialRegion: initialRegion,
            getAddressFromCoordinate: { .preview(coordinate: $0) }
        )
    }
    static func delayedPreview(
        _ initialRegion: CoordinateRegion = .townLondon
    ) -> AddressMapSearchViewModel {
        .init(
            initialRegion: initialRegion,
            getAddressFromCoordinate: { .delayedPreview(coordinate: $0) }
        )
    }
    static func failing(
        _ initialRegion: CoordinateRegion = .townLondon
    ) -> AddressMapSearchViewModel {
        .init(
            initialRegion: initialRegion,
            getAddressFromCoordinate: { .failing(coordinate: $0) }
        )
    }
}
#endif

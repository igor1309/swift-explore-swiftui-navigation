//
//  AddressMapSearchViewModel+preview.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import Foundation

#if DEBUG
public extension AddressMapSearchViewModel {
    
    static let preview: AddressMapSearchViewModel = .init(
        region: .townLondon,
        getAddressFromCoordinate: { .preview(coordinate: $0) }
    )
    static let delayedPreview: AddressMapSearchViewModel = .init(
        region: .townLondon,
        getAddressFromCoordinate: { .delayedPreview(coordinate: $0) }
    )
    static let failing: AddressMapSearchViewModel = .init(
        region: .townLondon,
        getAddressFromCoordinate: { .failing(coordinate: $0) }
    )
}
#endif

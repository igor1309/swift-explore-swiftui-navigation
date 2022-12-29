//
//  AddressMapSearchViewModel+preview.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import MapDomain

#if DEBUG
public extension AddressMapSearchViewModel {
    
    static let preview: AddressMapSearchViewModel = .init(
        initialRegion: .townLondon,
        getAddressFromCoordinate: { .preview(coordinate: $0) },
        getCompletions: getCompletions,
        search: { _ in .preview }
    )
    static let delayedPreview: AddressMapSearchViewModel = .init(
        initialRegion: .townLondon,
        getAddressFromCoordinate: { .delayedPreview(coordinate: $0) },
        getCompletions: getCompletions,
        search: { _ in .preview }
    )
    static let failing: AddressMapSearchViewModel = .init(
        initialRegion: .townLondon,
        getAddressFromCoordinate: { .failing(coordinate: $0) },
        getCompletions: getCompletions,
        search: { _ in .preview }
    )
    
    private static func getCompletions(text: String) -> CompletionsPublisher {
        if text.isEmpty {
            return .prevSearches
        } else {
            return .preview
        }
    }
}
#endif

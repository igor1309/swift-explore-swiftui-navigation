//
//  LocalSearchClient+live.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import MapKit

extension LocalSearchClient {
    
    public static var live: Self {
        .init { completion, region in
            /// `LocalSearchCompletion` has internal memberwise init for testing
            /// which sets `rawValue` to nil.
            /// `init(rawValue:)` does not set rawValue to nil
            guard let rawValue = completion.rawValue else {
                throw CompletionError()
            }
            
            let request = MKLocalSearch.Request(completion: rawValue)
            if let region {
                request.region = region.rawValue
            }
            let search = MKLocalSearch(request: request)
            return try await .init(rawValue: search.start())
        }
    }
    
    public struct CompletionError: Error {}
}

extension LocalSearchClient.CompletionError: LocalizedError {
    
    public var errorDescription: String? {
        "Completion was not not created using MKLocalSearchCompletion"
    }
}

extension LocalSearchClient.Response {
    
    public init(rawValue: MKLocalSearch.Response) {
        self.init(
            boundingRegion: .init(rawValue: rawValue.boundingRegion),
            mapItems: rawValue.mapItems.compactMap(MapItem.init(rawValue:))
        )
    }
}

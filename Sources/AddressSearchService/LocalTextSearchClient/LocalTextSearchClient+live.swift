//
//  LocalTextSearchClient+liveWithCompletion.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import MapKit

extension LocalTextSearchClient {
    
    public static var live: Self {
        .init { query, region in
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
            if let region {
                request.region = region.rawValue
            }
            let search = MKLocalSearch(request: request)
            return try await .init(rawValue: search.start())
        }
    }
}

extension LocalTextSearchClient.Response {
    
    public init(rawValue: MKLocalSearch.Response) {
        self.init(
            boundingRegion: .init(rawValue: rawValue.boundingRegion),
            mapItems: rawValue.mapItems.compactMap(MapItem.init(rawValue:))
        )
    }
}

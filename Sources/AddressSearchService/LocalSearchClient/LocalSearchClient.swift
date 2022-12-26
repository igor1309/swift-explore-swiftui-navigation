//
//  LocalSearchClient.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import MapDomain

public struct LocalSearchClient {
    
    /// `completion`
    /// A search completion object that MapKit obtains from an MKLocalSearchCompleter object.
    /// The search request uses the provided object to set the value of the naturalLanguageQuery property.
    /// 
    /// `region`
    /// A map region that provides a hint as to where to search.
    /// You can use this parameter to narrow the list of search results
    /// to those inside or close to the specified region. Specifying a region
    /// doesn’t ensure that the results are all inside the region.
    /// It’s merely a hint to the search engine.
    public typealias Search = (LocalSearchCompletion, CoordinateRegion?) async throws -> Response
    
    public let search: Search
    
    public init(search: @escaping Search) {
        self.search = search
    }
    
    public struct Response: Equatable {
        
        public let boundingRegion: CoordinateRegion
        public let mapItems: [MapItem]
        
        public init(boundingRegion: CoordinateRegion, mapItems: [MapItem]) {
            self.boundingRegion = boundingRegion
            self.mapItems = mapItems
        }
    }
}

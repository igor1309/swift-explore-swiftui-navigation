//
//  LocalSearchClient.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import MapDomain

public struct LocalSearchClient {
    
    public let search: (LocalSearchCompletion) async throws -> Response
    
    public init(search: @escaping (LocalSearchCompletion) async throws -> Response) {
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


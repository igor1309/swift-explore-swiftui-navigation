//
//  searchAddresses.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import MapDomain

extension LocalSearchClient {
    
    public func searchAddresses(
        _ completion: LocalSearchCompletion,
        region: CoordinateRegion? = nil
    ) async throws -> [Address] {
        try await .init(search(completion, region))
    }
}

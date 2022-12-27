//
//  searchAddresses.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import Combine
import MapDomain

extension LocalSearchClient {
    
    public func searchAddresses(
        _ completion: LocalSearchCompletion,
        region: CoordinateRegion? = nil
    ) async throws -> [Address] {
        try await .init(search(completion, region))
    }
    
    public func searchAddresses(
        _ completion: LocalSearchCompletion,
        region: CoordinateRegion? = nil
    ) -> AnyPublisher<Result<[Address], Error>, Never> {
        Deferred {
            Future { promise in
                Task {
                    try await searchAddresses(completion, region: region)
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

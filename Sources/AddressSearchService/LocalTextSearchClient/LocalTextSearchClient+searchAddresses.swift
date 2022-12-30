//
//  searchAddresses.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import Combine
import MapDomain

extension LocalTextSearchClient {
    
    public func searchAddresses(
        _ query: String,
        region: CoordinateRegion? = nil
    ) async throws -> [(Address, CoordinateRegion)] {
        try await .init(search(query, region))
    }
    
    public typealias SearchResult = Result<[(Address, CoordinateRegion)], Error>
    
    public func searchAddresses(
        _ query: String,
        region: CoordinateRegion? = nil
    ) -> AnyPublisher<SearchResult, Never> {
        Deferred {
            Future { promise in
                Task {
                    do {
                        let items = try await searchAddresses(query, region: region)
                        promise(.success(.success(items)))
                    } catch {
                        promise(.success(.failure(error)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

private extension Array where Element == (Address, CoordinateRegion) {
    
    init(_ response: LocalTextSearchClient.Response) {
        self = response.mapItems.map { mapItem in
            let address = Address(mapItem: mapItem)
            let region = response.boundingRegion
            
            return (address, region)
        }
    }
}

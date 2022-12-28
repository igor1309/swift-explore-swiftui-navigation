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
                    do {
                        let addresses = try await searchAddresses(completion, region: region)
                        promise(.success(.success(addresses)))
                    } catch {
                        promise(.success(.failure(error)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

private extension Array where Element == Address {
    
    init(_ response: LocalSearchClient.Response) {
        self = response.mapItems.compactMap(Address.init(mapItem:))
    }
}

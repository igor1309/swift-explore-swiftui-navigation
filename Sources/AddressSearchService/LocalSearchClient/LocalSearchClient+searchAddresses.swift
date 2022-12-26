//
//  searchAddresses.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

extension LocalSearchClient {
    
    public func searchAddresses(_ completion: LocalSearchCompletion) async throws -> [Address] {
        try await .init(search(completion))
    }
}

//
//  SearchAddressesTests.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import AddressSearchService
import MapDomain
import XCTest

final class SearchAddressesTests: XCTestCase {
    
    func test_searchAddresses_returnsEmptyOnEmptyMapItems() async throws {
        let localSearchClient: LocalSearchClient = .test(mapItems: [])
        let completion: LocalSearchCompletion = .test
        
        let addresses = try await localSearchClient.searchAddresses(completion)
        
        XCTAssertEqual(addresses, [])
    }
    
    func test_searchAddresses_returns___MapItems() async throws {
        let localSearchClient: LocalSearchClient = .test()
        let completion: LocalSearchCompletion = .test
        
        let addresses = try await localSearchClient.searchAddresses(completion)
        
        XCTAssertEqual(addresses, [.empty, .empty])
    }
}

// MARK: - Helpers

private extension LocalSearchClient {
    
    static func test(mapItems: [MapItem] = .test) -> Self {
        .init { completion in
                .init(
                    boundingRegion: .test,
                    mapItems: mapItems
                )
        }
    }
}

private extension CoordinateRegion {
    
    static let test: Self = .init(center: .test, span: .test)
}

private extension LocationCoordinate2D {
    
    static let test: Self = .init(latitude: 1, longitude: 1)
}

private extension CoordinateSpan {
    
    static let test: Self = .init(latitudeDelta: 1, longitudeDelta: 1)
}

private extension Array where Element == MapItem {
    
    static let test: Self = [.empty, .empty]
}

private extension MapItem {
    
    static let empty: Self = .init(
        coordinate: .test,
        postalAddress: .init(street: "", city: "")
    )
}

private extension Address {
    
    static let empty: Self = .init(street: "", city: "")
}

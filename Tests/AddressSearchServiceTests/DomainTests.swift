//
//  DomainTests.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import AddressSearchService
import MapDomain
import XCTest

final class DomainTests: XCTestCase {
    
    func test_initAddress_shouldSetProperties() {
        let address = Address(street: "Street", city: "City")
        
        XCTAssertEqual(address.street, "Street")
        XCTAssertEqual(address.city, "City")
    }
    
    func test_initMapItem_shouldSetProperties() {
        let mapItem = MapItem(
            coordinate: .test,
            address: .test
        )
        
        XCTAssertEqual(mapItem.coordinate, .test)
        XCTAssertEqual(mapItem.address, .test)
    }
}

// MARK: - Helpers

private extension LocationCoordinate2D {
    
    static let test: Self = .init(
        latitude: 1, longitude: 2
    )
}

private extension Address {
    
    static let test: Self = .init(
        street: "TestStreet", city: "TestCity"
    )
}

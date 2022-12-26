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
            postalAddress: .test
        )
        
        XCTAssertEqual(mapItem.coordinate, .test)
        XCTAssertEqual(mapItem.postalAddress, .test)
    }
    
    func test_initPostalAddress_shouldSetProperties() {
        let address = PostalAddress(street: "TestStreet", city: "TestCity")
        
        XCTAssertEqual(address.street, "TestStreet")
        XCTAssertEqual(address.city, "TestCity")
    }
    
}

// MARK: - Helpers

private extension LocationCoordinate2D {
    
    static let test: Self = .init(
        latitude: 1, longitude: 2
    )
}

private extension PostalAddress {
    
    static let test: Self = .init(
        street: "TestStreet", city: "TestCity"
    )
}

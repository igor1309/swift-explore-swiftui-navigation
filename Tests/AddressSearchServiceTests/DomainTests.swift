//
//  DomainTests.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import AddressSearchService
import MapDomain
import MapKit
import XCTest
import Contacts

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
    
    func test_address_shouldBridgeToRawValue() {
        let address = Address(street: "Street", city: "City")
        
        let rawValue = address.rawValue
        
        XCTAssertEqual(rawValue.street, "Street")
        XCTAssertEqual(rawValue.city, "City")
    }
    
    func test_address_shouldBridgeFromRawValue() {
        let rawValue = {
            let cnMutablePostalAddress = CNMutablePostalAddress()
            cnMutablePostalAddress.street = "Street"
            cnMutablePostalAddress.city = "City"
            return cnMutablePostalAddress
        }()
        
        let address = Address(rawValue: rawValue)
        
        XCTAssertEqual(address.street, "Street")
        XCTAssertEqual(address.city, "City")
    }
    
    func test_mapItem_shouldBridgeToRawValue() {
        let mapItem = MapItem(
            coordinate: .test,
            address: .test
        )
        
        let rawValue = mapItem.rawValue
        XCTAssertEqual(
            .init(rawValue: rawValue.placemark.coordinate),
            LocationCoordinate2D.test
        )
        
        let postalAddress = rawValue.placemark.postalAddress
        XCTAssertEqual(postalAddress?.street, "TestStreet")
        XCTAssertEqual(postalAddress?.city, "TestCity")
    }
    
    func test_mapItem_shouldBridgeFromRawValue() {
        let rawValue = MKMapItem.test
        
        let mapItem = MapItem(rawValue: rawValue)
        
        XCTAssertEqual(mapItem?.coordinate, .test)
        XCTAssertEqual(mapItem?.address.street, "TestStreet")
        XCTAssertEqual(mapItem?.address.city, "TestCity")

    }
}

// MARK: - Helpers

private extension LocationCoordinate2D {
    
    static let test: Self = .init(latitude: 1, longitude: 2)
}

private extension Address {
    
    static let test: Self = .init(street: "TestStreet", city: "TestCity")
}

private extension MKMapItem {
    
    static let test: MKMapItem = .init(
        placemark: .init(
            coordinate: .init(latitude: 1, longitude: 2),
            postalAddress: {
                let cnMutablePostalAddress = CNMutablePostalAddress()
                cnMutablePostalAddress.street = "TestStreet"
                cnMutablePostalAddress.city = "TestCity"
                return cnMutablePostalAddress
            }()
        )
    )
}

//
//  MapDomainTests.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

import CoreLocation
import MapDomain
import MapKit
import XCTest

final class MapDomainTests: XCTestCase {
    
    func test_initLocationCoordinate2D_shouldSetProperties() {
        let latitude = 52.2
        let longitude = 12.3
        let coordinate = LocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        XCTAssertEqual(coordinate.latitude, latitude)
        XCTAssertEqual(coordinate.longitude, longitude)
    }
    
    func test_initCoordinateSpan_shouldSetProperties() {
        let latitudeDelta = 12.3
        let longitudeDelta = 45.6
        let span = CoordinateSpan(
            latitudeDelta: latitudeDelta,
            longitudeDelta: longitudeDelta
        )
        
        XCTAssertEqual(span.latitudeDelta, latitudeDelta)
        XCTAssertEqual(span.longitudeDelta, longitudeDelta)
    }
    
    func test_initCoordinateRegion_shouldSetProperties() {
        let latitude = 52.2
        let longitude = 12.3
        let center = LocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        let latitudeDelta = 12.3
        let longitudeDelta = 45.6
        let span = CoordinateSpan(
            latitudeDelta: latitudeDelta,
            longitudeDelta: longitudeDelta
        )
        
        let region = CoordinateRegion(
            center: center,
            span: span
        )
        
        XCTAssertEqual(region.center, center)
        XCTAssertEqual(region.span, span)
    }
    
    func test_locationCoordinate2D_shouldBridgeToCLLocationCoordinate2D() {
        let latitude = 52.2
        let longitude = 12.3
        let coordinate = LocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        let clLocationCoordinate2D = coordinate.rawValue
        
        XCTAssertEqual(clLocationCoordinate2D.latitude, latitude)
        XCTAssertEqual(clLocationCoordinate2D.longitude, longitude)
    }
    
    func test_locationCoordinate2D_shouldBridgeFromCLLocationCoordinate2D() {
        var coordinate = LocationCoordinate2D.zero
        XCTAssertEqual(coordinate.latitude, 0)
        XCTAssertEqual(coordinate.longitude, 0)

        let latitude = 52.2
        let longitude = 12.3
        let clLocationCoordinate2D = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        coordinate.rawValue = clLocationCoordinate2D
        
        XCTAssertEqual(coordinate.latitude, latitude)
        XCTAssertEqual(coordinate.longitude, longitude)
    }
    
    func test_coordinateSpan_shouldBridgeToMKCoordinateSpan() {
        let latitudeDelta = 12.3
        let longitudeDelta = 45.6
        let span = CoordinateSpan(
            latitudeDelta: latitudeDelta,
            longitudeDelta: longitudeDelta
        )
        
        let mkCoordinateSpan = span.rawValue
        
        XCTAssertEqual(mkCoordinateSpan.latitudeDelta, latitudeDelta)
        XCTAssertEqual(mkCoordinateSpan.longitudeDelta, longitudeDelta)
    }
    
    func test_coordinateSpan_shouldBridgeFromMKCoordinateSpan() {
        var span = CoordinateSpan.zero
        XCTAssertEqual(span.latitudeDelta, 0)
        XCTAssertEqual(span.longitudeDelta, 0)

        let latitudeDelta = 12.3
        let longitudeDelta = 45.6
        let mkCoordinateSpan = MKCoordinateSpan(
            latitudeDelta: latitudeDelta,
            longitudeDelta: longitudeDelta
        )
        
        span.rawValue = mkCoordinateSpan
        
        XCTAssertEqual(span.latitudeDelta, latitudeDelta)
        XCTAssertEqual(span.longitudeDelta, longitudeDelta)
    }
    
    func test_coordinateRegion_shouldBridgeToMKCoordinateRegion() {
        let latitude = 52.2
        let longitude = 12.3
        let center = LocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        let latitudeDelta = 12.3
        let longitudeDelta = 45.6
        let span = CoordinateSpan(
            latitudeDelta: latitudeDelta,
            longitudeDelta: longitudeDelta
        )
        
        let region = CoordinateRegion(
            center: center,
            span: span
        )
        
        let mkCoordinateRegion = region.rawValue
        
        XCTAssertEqual(mkCoordinateRegion.center.latitude, latitude)
        XCTAssertEqual(mkCoordinateRegion.center.longitude, longitude)
        XCTAssertEqual(mkCoordinateRegion.span.latitudeDelta, latitudeDelta)
        XCTAssertEqual(mkCoordinateRegion.span.longitudeDelta, longitudeDelta)
    }

    func test_coordinateRegion_shouldBridgeFromMKCoordinateRegion() {
        var region = CoordinateRegion.zero
        XCTAssertEqual(region.center, .zero)
        XCTAssertEqual(region.span, .zero)
        
        let latitude = 52.2
        let longitude = 12.3
        let center = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        let latitudeDelta = 12.3
        let longitudeDelta = 45.6
        let span = MKCoordinateSpan(
            latitudeDelta: latitudeDelta,
            longitudeDelta: longitudeDelta
        )
        
        let mkCoordinateRegion = MKCoordinateRegion(
            center: center,
            span: span
        )
        
        region.rawValue = mkCoordinateRegion
        
        XCTAssertEqual(region.center.latitude, latitude)
        XCTAssertEqual(region.center.longitude, longitude)
        XCTAssertEqual(region.span.latitudeDelta, latitudeDelta)
        XCTAssertEqual(region.span.longitudeDelta, longitudeDelta)
    }
}

//
//  MapViewModelTests.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import Combine
import CombineSchedulers
@testable import MapFeature
import MapKit
import XCTest

final class MapViewModelTests: XCTestCase {
    
    func test_init_shouldSetStreetToNil() {
        let scheduler = DispatchQueue.test
        let (sut, locationSpy, streetSpy) = makeSUT(
            stub: nil,
            scheduler: scheduler.eraseToAnyScheduler()
        )
        
        XCTAssertEqual(streetSpy.values, [nil])
        XCTAssertNotNil(sut)
        XCTAssertNotNil(locationSpy)
    }
    
    func test__() {
        let scheduler = DispatchQueue.test
        let (sut, _, streetSpy) = makeSUT(
            stub: "Blue Stret, 123",
            scheduler: scheduler.eraseToAnyScheduler()
        )
        
        XCTAssertEqual(streetSpy.values, [nil])
        
//        scheduler.advance()
        scheduler.advance(by: .seconds(1))
        XCTAssertEqual(streetSpy.values, [nil])
        
        sut.update(region: .moscowStreet)
        scheduler.advance()
//        scheduler.advance(by: .seconds(1))
        XCTAssertEqual(streetSpy.values, [nil, "Blue Stret, 123"])
        
        sut.update(region: .moscowStreet)

        scheduler.advance(by: .seconds(1))
        XCTAssertEqual(streetSpy.values, [nil, "Blue Stret, 123"])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        stub: String?,
        scheduler: AnySchedulerOf<DispatchQueue>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: MapViewModel,
        locationSpy: LocationSpy,
        streetSpy: ValueSpy<String?>
    ) {
        let initialRegion: MKCoordinateRegion = .londonStreet
        let locationSpy = LocationSpy(stub: stub)
        let sut = MapViewModel(
            initialRegion: initialRegion,
            getStreetFrom: locationSpy.getStreetFrom,
            //getStreetFrom: { _ in Just(stub).eraseToAnyPublisher() },
            scheduler: scheduler
        )
        let streetSpy = ValueSpy(sut.$street)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(locationSpy, file: file, line: line)
        trackForMemoryLeaks(streetSpy, file: file, line: line)
        
        return (sut, locationSpy, streetSpy)
    }
    
    private final class LocationSpy {
        private let stub: String?
        
        init(stub: String?) {
            self.stub = stub
        }
        
        func getStreetFrom(coordinate: CLLocationCoordinate2D) async -> String? {
            return stub
        }
    }
    
    private final class ValueSpy<Value> {
        private(set) var values = [Value]()
        private var cancellable: AnyCancellable?
        
        init<P>(_ publisher: P) where P: Publisher, P.Output == Value, P.Failure == Never {
            cancellable = publisher.sink { [weak self] in
                self?.values.append($0)
            }
        }
    }
}

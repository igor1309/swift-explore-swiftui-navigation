//
//  MapViewModelTests.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import Combine
import CombineSchedulers
import MapDomain
@testable import AddressMapSearchFeature
import MapKit
import XCTest

final class MapViewModelTests: XCTestCase {
    
    func test_init_shouldSetStreetToNil() {
        let scheduler = DispatchQueue.test
        let (sut, locationSpy, streetSpy) = makeSUT(
            stub: nil,
            scheduler: scheduler.eraseToAnyScheduler()
        )
        
        XCTAssertEqual(streetSpy.values, [.none])
        XCTAssertNotNil(sut)
        XCTAssertNotNil(locationSpy)
    }
    
    func test__() {
        let scheduler = DispatchQueue.test
        let (sut, _, streetSpy) = makeSUT(
            stub: .test,
            scheduler: scheduler.eraseToAnyScheduler()
        )
        
        XCTAssertEqual(streetSpy.values, [.none])
        
        //        scheduler.advance()
        scheduler.advance(by: .seconds(1))
        XCTAssertEqual(streetSpy.values, [.none])
        
        sut.update(region: .streetMoscow)
        scheduler.advance()
        //        scheduler.advance(by: .seconds(1))
        XCTAssertEqual(streetSpy.values, [.none, .address(.test)])
        
        sut.update(region: .streetMoscow)
        
        scheduler.advance(by: .seconds(1))
        XCTAssertEqual(streetSpy.values, [.none, .address(.test)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        stub: Address?,
        scheduler: AnySchedulerOf<DispatchQueue>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: AddressMapSearchViewModel,
        locationSpy: LocationSpy,
        streetSpy: ValueSpy<AddressMapSearchViewModel.AddressState>
    ) {
        let initialRegion: CoordinateRegion = .streetLondon
        let locationSpy = LocationSpy(stub: stub)
        let sut = AddressMapSearchViewModel(
            initialRegion: initialRegion,
            getAddressFromCoordinate: locationSpy.getAddressFromCoordinate,
            //getStreetFrom: { _ in Just(stub).eraseToAnyPublisher() },
            scheduler: scheduler
        )
        let streetSpy = ValueSpy(sut.$addressState)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(locationSpy, file: file, line: line)
        trackForMemoryLeaks(streetSpy, file: file, line: line)
        
        return (sut, locationSpy, streetSpy)
    }
    
    private final class LocationSpy {
        private let stub: Address?
        
        init(stub: Address?) {
            self.stub = stub
        }
        
        func getAddressFromCoordinate(
            coordinate: LocationCoordinate2D
        ) -> AddressMapSearchViewModel.AddressPublisher {
            Just(stub).eraseToAnyPublisher()
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

private extension Address {
    
    static let test: Self = .init(street: "Blue Stret, 123", city: "NCity")
}

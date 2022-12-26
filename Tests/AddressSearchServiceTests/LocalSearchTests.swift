//
//  LocalSearchTests.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

@testable import AddressSearchService
import MapFeature
import MapKit
import XCTest

struct LocalSearchClient {
    let search: (LocalSearchCompletion) async throws -> Response
    
    struct Response: Equatable {
        let boundingRegion: CoordinateRegion
        let mapItems: [MapItem]
    }
}

struct MapItem: Equatable {
    
    /// The placemark object containing the location information.
    let placemark: MKPlacemark
}

extension MapItem: RawRepresentable {
    
    var rawValue: MKMapItem {
        .init(placemark: placemark)
    }
    
    init(rawValue: MKMapItem) {
        self.placemark = rawValue.placemark
    }
}

extension LocalSearchClient.Response {
    
    init(rawValue: MKLocalSearch.Response) {
        self.init(
            boundingRegion: .init(rawValue: rawValue.boundingRegion),
            mapItems: rawValue.mapItems.map(MapItem.init(rawValue:))
        )
    }
}

extension LocalSearchClient {
    
    static var live: Self {
        .init { completion in
            /// `LocalSearchCompletion` has internal memberwise init for testing
            /// which sets `rawValue` to nil.
            /// `init(rawValue:)` does not set rawValue to nil
            guard let rawValue = completion.rawValue else {
                throw CompletionError()
            }
            
            let search = MKLocalSearch(request: .init(completion: rawValue))
            return try await .init(rawValue: search.start())
        }
    }
    
    struct CompletionError: Error {}
}

extension LocalSearchClient.CompletionError: LocalizedError {
    
    var errorDescription: String? {
        "Completion was not not created using MKLocalSearchCompletion"
    }
}

final class LocalSearchTests: XCTestCase {

    func test() {
        
    }
}

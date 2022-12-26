import Contacts
import MapKit
import AddressSearchService
import MapFeature

struct Address {
    let street: String
    let city: String
}

extension Address {
    
    init?(mapItem: MKMapItem) {
        guard let postalAddress = mapItem.placemark.postalAddress
        else {
            return nil
        }
        
        self.street = postalAddress.street
        self.city = postalAddress.city
    }
}

extension Array where Element == Address {
    
    init(_ response: MKLocalSearch.Response) {
        self = response.mapItems.compactMap(Address.init(mapItem:))
    }
}

enum LocalSearch {
    
    static func search(_ query: String) async throws -> [Address] {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        let mkLocalSearch = MKLocalSearch(request: searchRequest)
        let mapItems = try await mkLocalSearch.start().mapItems
        let addresses = mapItems.compactMap(Address.init(mapItem:))
        return addresses
    }
    
    static func search(_ completion: MKLocalSearchCompletion) async throws -> [Address] {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let mkLocalSearch = MKLocalSearch(request: .init(completion: completion))
        let mapItems = try await mkLocalSearch.start().mapItems
        return mapItems.compactMap(Address.init(mapItem:))
    }
    
    /// `LocalSearchCompletion` has internal memberwise init for testing
    /// which sets `rawValue` to nil.
    /// `init(rawValue:)` does not set rawValue to nil
    static func search(_ completion: LocalSearchCompletion) async throws -> Response {
        guard let completion = completion.rawValue else {
            throw NSError(domain: "Completion not created using MKLocalSearchCompletion", code: 0)
        }
        let mkLocalSearch = MKLocalSearch(request: .init(completion: completion))
        return try await .init(rawValue: mkLocalSearch.start())
    }
    
    struct Response: Equatable {
        let boundingRegion: CoordinateRegion
        let mapItems: [MKMapItem]
    }
    
    /// `LocalSearchCompletion` has internal memberwise init for testing
    /// which sets `rawValue` to nil.
    /// `init(rawValue:)` does not set rawValue to nil
    static func search(_ completion: LocalSearchCompletion) async throws -> [Address] {
        guard let completion = completion.rawValue else {
            throw NSError(domain: "Completion not created using MKLocalSearchCompletion", code: 0)
        }
        //let searchRequest = MKLocalSearch.Request(completion: completion)
        let mkLocalSearch = MKLocalSearch(request: .init(completion: completion))
        // let mapItems = try await mkLocalSearch.start().mapItems
        // return mapItems.compactMap(Address.init(mapItem:))
        return try await .init(mkLocalSearch.start())
    }
}

extension LocalSearch.Response {
    
    init(rawValue: MKLocalSearch.Response) {
        self.init(
            boundingRegion: .init(rawValue: rawValue.boundingRegion),
            mapItems: rawValue.mapItems
        )
    }
}

Task {
    let streets = try await LocalSearch.search("coffee").map(\.street)
    streets.forEach { print($0) }
}

try? await Task.sleep(nanoseconds: NSEC_PER_SEC)

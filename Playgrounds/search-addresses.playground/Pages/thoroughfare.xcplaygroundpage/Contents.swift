import Contacts
import MapKit

struct Address {
    let street: String
    let city: String
}

extension Address {
    
    init?(mapItem: MKMapItem) {
        guard let thoroughfare = mapItem.placemark.thoroughfare,
              let subThoroughfare = mapItem.placemark.subThoroughfare
        else {
            return nil
        }
        
        self.street = thoroughfare
        self.city = subThoroughfare
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
}

Task {
    let streets = try await LocalSearch.search("coffee").map(\.street)
    streets.forEach { print($0) }
}

try? await Task.sleep(nanoseconds: NSEC_PER_SEC)

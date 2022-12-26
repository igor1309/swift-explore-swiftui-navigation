import Contacts
import MapKit

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


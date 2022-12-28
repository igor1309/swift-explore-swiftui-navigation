//
//  MapViewModel+ext.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

#if DEBUG
import Contacts
import MapDomain
import MapKit

public extension MapViewModel {
    
    static let preview: MapViewModel = .init(
        initialRegion: .streetLondon,
        getStreetFrom: { _ in
            .init(street: "Review Street, 0123", city: "NCity")
        }
    )
    
    static let failing: MapViewModel = .init(
        initialRegion: .streetLondon,
        getStreetFrom: { coordinate in nil }
    )
    
    static func live(region: CoordinateRegion = .streetLondon) -> MapViewModel {
        .init(
            initialRegion: region,
            getStreetFrom: { coordinate -> Address? in
                do {
                    let geocoder = CLGeocoder()
                    let placemarks = try await geocoder.reverseGeocodeLocation(coordinate.clLocation)
                    
                    guard let placemark = placemarks.first,
                          let address = placemark.postalAddress
                    else {
                        return nil
                    }
                    // return CNPostalAddressFormatter.string(
                    //     from: address,
                    //     style: .mailingAddress
                    // )
                    return .init(street: address.street, city: address.city)
                    
                } catch {
                    return nil
                }
            }
        )
    }
}

import CoreLocation
private extension LocationCoordinate2D {
    
    var clLocation: CLLocation {
        .init(latitude: latitude, longitude: longitude)
    }
}

#endif

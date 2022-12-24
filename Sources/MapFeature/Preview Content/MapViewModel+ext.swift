//
//  MapViewModel+ext.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

#if DEBUG
import Contacts
import MapKit

public extension MapViewModel {
    
    static let preview: MapViewModel = .init(
        initialRegion: .londonStreet,
        getStreetFrom: { coordinate in "Review Street, 0123" }
    )
    
    static let failing: MapViewModel = .init(
        initialRegion: .londonStreet,
        getStreetFrom: { coordinate in nil }
    )
    
    static func live(region: MKCoordinateRegion = .londonStreet) -> MapViewModel {
        .init(
            initialRegion: region,
            getStreetFrom: { coordinate in
                let clLocation = CLLocation(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )
                let clGeocoder = CLGeocoder()
                do {
                    guard let placemark = try await clGeocoder.reverseGeocodeLocation(clLocation).first,
                          let address = placemark.postalAddress
                    else {
                        return nil
                    }
                    return CNPostalAddressFormatter.string(
                        from: address,
                        style: .mailingAddress
                    )
                    
                } catch {
                    return nil
                }
            }
        )
        
    }
}
#endif

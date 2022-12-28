//
//  File.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import Contacts
import MapDomain
import MapKit

public extension GeocoderAddressCoordinateSearch {
    
    func getAddress(from coordinate: LocationCoordinate2D) async -> Address? {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(coordinate.clLocation)
            
            guard let placemark = placemarks.first,
                  let address = placemark.postalAddress
            else {
                return nil
            }
            
            return .init(street: address.street, city: address.city)
            
        } catch {
            return nil
        }
    }
}

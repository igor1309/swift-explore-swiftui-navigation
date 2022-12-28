//
//  GeocoderAddressCoordinateSearch.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import Contacts
import CoreLocation
import MapDomain
import MapKit

public final class GeocoderAddressCoordinateSearch {
    
    private let geocoder: CLGeocoder
    
    public init(geocoder: CLGeocoder = .init()) {
        self.geocoder = geocoder
    }
}

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

import Combine

public extension GeocoderAddressCoordinateSearch {
    
    func getAddress(
        from coordinate: LocationCoordinate2D
    ) -> AnyPublisher<Address?, Never> {
        return Deferred {
            Future { promise in
                Task {
                    let address = await self.getAddress(from: coordinate)
                    promise(.success(address))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}


// MARK: - Adapter

private extension LocationCoordinate2D {
    
    var clLocation: CLLocation {
        .init(latitude: latitude, longitude: longitude)
    }
}

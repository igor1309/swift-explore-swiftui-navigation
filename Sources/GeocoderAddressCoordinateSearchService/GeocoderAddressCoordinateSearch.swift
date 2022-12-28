//
//  GeocoderAddressCoordinateSearch.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import MapKit

public final class GeocoderAddressCoordinateSearch {
    
    let geocoder: CLGeocoder
    
    public init(geocoder: CLGeocoder = .init()) {
        self.geocoder = geocoder
    }
}

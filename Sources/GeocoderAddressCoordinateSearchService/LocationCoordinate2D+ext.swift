//
//  File.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import CoreLocation
import MapDomain

// MARK: - Adapter

extension LocationCoordinate2D {
    
    var clLocation: CLLocation {
        .init(latitude: latitude, longitude: longitude)
    }
}

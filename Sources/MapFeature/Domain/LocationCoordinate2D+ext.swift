//
//  LocationCoordinate2D+ext.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

import MapKit

extension LocationCoordinate2D {
    
    public static let zero: Self = .init(latitude: 0, longitude: 0)
    
    /// A bridge to `CLLocationCoordinate2D`
    public var clLocationCoordinate2D: CLLocationCoordinate2D {
        get { .init(latitude: latitude, longitude: longitude) }
        set {
            self = .init(
                latitude: newValue.latitude,
                longitude: newValue.longitude
            )
        }
    }
}

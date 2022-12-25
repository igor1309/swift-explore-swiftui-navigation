//
//  LocationCoordinate2D+ext.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

import MapKit

extension LocationCoordinate2D {
    
    public static let zero: Self = .init(latitude: 0, longitude: 0)
}

extension LocationCoordinate2D: RawRepresentable {
    
    /// A bridge to `CLLocationCoordinate2D`
    public var rawValue: CLLocationCoordinate2D {
        get { .init(latitude: latitude, longitude: longitude) }
        set { self = .init(rawValue: newValue) }
    }
    
    public init(rawValue: CLLocationCoordinate2D) {
        self.init(latitude: rawValue.latitude, longitude: rawValue.longitude)
    }
}

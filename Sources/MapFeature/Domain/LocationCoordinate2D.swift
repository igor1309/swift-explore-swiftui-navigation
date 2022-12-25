//
//  LocationCoordinate2D.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

public struct LocationCoordinate2D: Equatable {

    /// The latitude in degrees.
    public var latitude: LocationDegrees

    /// The longitude in degrees.
    public var longitude: LocationDegrees
    
    public init(latitude: LocationDegrees, longitude: LocationDegrees) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

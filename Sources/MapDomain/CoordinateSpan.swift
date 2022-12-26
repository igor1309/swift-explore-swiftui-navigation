//
//  CoordinateSpan.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

public struct CoordinateSpan: Equatable {
    
    /// The amount of north-to-south distance (measured in degrees) to display on the map.
    public var latitudeDelta: LocationDegrees

    /// The amount of east-to-west distance (measured in degrees) to display for the map region.
    public var longitudeDelta: LocationDegrees
    
    public init(latitudeDelta: LocationDegrees, longitudeDelta: LocationDegrees) {
        self.latitudeDelta = latitudeDelta
        self.longitudeDelta = longitudeDelta
    }
}

//
//  MapItem.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import MapDomain

public struct MapItem: Equatable {
    
    /// Coordinate
    public let coordinate: LocationCoordinate2D
    
    /// The postal address.
    public let address: Address
    
    public init(coordinate: LocationCoordinate2D, address: Address) {
        self.coordinate = coordinate
        self.address = address
    }
}

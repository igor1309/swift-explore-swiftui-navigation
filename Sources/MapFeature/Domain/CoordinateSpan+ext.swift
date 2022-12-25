//
//  CoordinateSpan+ext.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

import MapKit

extension CoordinateSpan {
    
    public static let zero: Self = .init(latitudeDelta: 0, longitudeDelta: 0)
    
    /// A bridge to `MKCoordinateSpan`
    public var mkCoordinateSpan: MKCoordinateSpan {
        get {
            .init(
                latitudeDelta: latitudeDelta,
                longitudeDelta: longitudeDelta
            )
        }
        set {
            self = .init(
                latitudeDelta: newValue.latitudeDelta,
                longitudeDelta: newValue.longitudeDelta
            )
        }
    }
}

//
//  CoordinateSpan+ext.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

import MapKit

extension CoordinateSpan {
    
    public static let zero: Self = .init(latitudeDelta: 0, longitudeDelta: 0)
}

extension CoordinateSpan: RawRepresentable {

    /// A bridge to `MKCoordinateSpan`
    public var rawValue: MKCoordinateSpan {
        get {
            .init(
                latitudeDelta: latitudeDelta,
                longitudeDelta: longitudeDelta
            )
        }
        set { self = .init(rawValue: newValue) }
    }
    
    public init(rawValue: MKCoordinateSpan) {
        self.init(
            latitudeDelta: rawValue.latitudeDelta,
            longitudeDelta: rawValue.longitudeDelta
        )
    }
}

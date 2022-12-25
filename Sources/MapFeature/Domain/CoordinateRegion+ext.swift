//
//  CoordinateRegion+ext.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

import MapKit

extension CoordinateRegion {
    
    public static let zero: Self = .init(center: .zero, span: .zero)
    
    /// A bridge to `MKCoordinateRegion`
    public var mkCoordinateRegion: MKCoordinateRegion {
        get {
            .init(
                center: center.clLocationCoordinate2D,
                span: span.mkCoordinateSpan
            )
        }
        
        set {
            self = .init(
                center: .init(
                    latitude: newValue.center.latitude,
                    longitude: newValue.center.longitude
                ),
                span: .init(
                    latitudeDelta: newValue.span.latitudeDelta,
                    longitudeDelta: newValue.span.longitudeDelta
                )
            )
        }
    }
}

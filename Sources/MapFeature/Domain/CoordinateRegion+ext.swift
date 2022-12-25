//
//  CoordinateRegion+ext.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

import MapKit

extension CoordinateRegion {
    
    public static let zero: Self = .init(center: .zero, span: .zero)
}

extension CoordinateRegion: RawRepresentable {
    
    /// A bridge to `MKCoordinateRegion`
    public var rawValue: MKCoordinateRegion {
        get {
            .init(
                center: center.rawValue,
                span: span.rawValue
            )
        }
        set { self = .init(rawValue: newValue) }
    }
    
    public init(rawValue: MKCoordinateRegion) {
        self.init(
            center: .init(rawValue: rawValue.center),
            span: .init(rawValue: rawValue.span)
        )
    }
}

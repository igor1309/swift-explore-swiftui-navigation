//
//  MapItem+ext.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import MapKit

extension MapItem: RawRepresentable {
    
    public var rawValue: MKMapItem {
        .init(
            placemark: .init(
                coordinate: coordinate.rawValue,
                postalAddress: postalAddress.rawValue
            )
        )
    }
    
    public init?(rawValue: MKMapItem) {
        guard let postalAddress = rawValue.placemark.postalAddress else {
            return nil
        }
        
        self.init(
            coordinate: .init(rawValue: rawValue.placemark.coordinate),
            postalAddress: .init(rawValue: postalAddress)
        )
    }
}

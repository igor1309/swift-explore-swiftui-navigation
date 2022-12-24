//
//  MKCoordinateRegion+ext.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import MapKit

#if DEBUG
extension MKCoordinateRegion {
    
    static let barcelonaNeighborhood: Self = .init(
        center: .barcelona,
        span: .neighborhood
    )
    static let londonCity: Self = .init(
        center: .london,
        span: .city
    )
    static let londonTown: Self = .init(
        center: .london,
        span: .town
    )
    static let londonNeighborhood: Self = .init(
        center: .london,
        span: .neighborhood
    )
    static let londonStreet: Self = .init(
        center: .london,
        span: .street
    )
}
#endif

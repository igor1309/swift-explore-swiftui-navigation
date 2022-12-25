//
//  CoordinateRegion+preview.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import MapKit

#if DEBUG
public extension CoordinateRegion {
    
    static let barcelonaNeighborhood: Self = .neighborhood(center: .barcelona)
    static let barcelonaStreet:       Self = .street(center: .barcelona)
    static let londonCity:            Self = .city(center: .london)
    static let londonTown:            Self = .town(center: .london)
    static let londonNeighborhood:    Self = .neighborhood(center: .london)
    static let londonStreet:          Self = .street(center: .london)
    static let moscowCity:            Self = .city(center: .moscow)
    static let moscowStreet:          Self = .street(center: .moscow)
    static let moscowNeighborhood:    Self = .neighborhood(center: .moscow)
    
    static func city(center: LocationCoordinate2D) -> Self {
        .init(center: center, span: .city)
    }
    static func town(center: LocationCoordinate2D) -> Self {
        .init(center: center, span: .town)
    }
    static func neighborhood(center: LocationCoordinate2D) -> Self {
        .init(center: center, span: .neighborhood)
    }
    static func street(center: LocationCoordinate2D) -> Self {
        .init(center: center, span: .street)
    }
}
#endif

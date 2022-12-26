//
//  CoordinateRegion+preview.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import MapDomain

#if DEBUG
public extension CoordinateRegion {
    
    static let londonCity:            Self = .city(center: .london)
    static let moscowCity:            Self = .city(center: .moscow)

    static let barcelonaNeighborhood: Self = .neighborhood(center: .barcelona)
    static let londonNeighborhood:    Self = .neighborhood(center: .london)
    static let moscowNeighborhood:    Self = .neighborhood(center: .moscow)
    
    static let barcelonaStreet:       Self = .street(center: .barcelona)
    static let londonStreet:          Self = .street(center: .london)
    static let moscowStreet:          Self = .street(center: .moscow)

    static let londonTown:            Self = .town(center: .london)
    
    static func city(center: LocationCoordinate2D) -> Self {
        .init(center: center, span: .city)
    }
    static func neighborhood(center: LocationCoordinate2D) -> Self {
        .init(center: center, span: .neighborhood)
    }
    static func street(center: LocationCoordinate2D) -> Self {
        .init(center: center, span: .address)
    }
    static func town(center: LocationCoordinate2D) -> Self {
        .init(center: center, span: .town)
    }
}
#endif

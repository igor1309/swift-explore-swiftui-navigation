//
//  CoordinateRegion+preview.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import MapDomain

#if DEBUG
public extension CoordinateRegion {
    
    static let cityLondon:            Self = .city(center: .london)
    static let cityMoscow:            Self = .city(center: .moscow)

    static let neighborhoodBarcelona: Self = .neighborhood(center: .barcelona)
    static let neighborhoodLondon:    Self = .neighborhood(center: .london)
    static let neighborhoodMoscow:    Self = .neighborhood(center: .moscow)
    
    static let streetBarcelona:       Self = .street(center: .barcelona)
    static let streetLondon:          Self = .street(center: .london)
    static let streetMoscow:          Self = .street(center: .moscow)

    static let townLondon:            Self = .town(center: .london)
    
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

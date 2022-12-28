//
//  CoordinateSpan+ext.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import MapDomain

#if DEBUG
public extension CoordinateSpan {
    
    static var regional:     Self = .init(8,     8)
    static var area:         Self = .init(2,     2)
    static var city:         Self = .init(0.5,   0.5)
    static var town:         Self = .init(0.1,   0.1)
    static var neighborhood: Self = .init(0.01,  0.01)
    static var address:      Self = .init(0.001, 0.001)
    
    private init(
        _ latitudeDelta: LocationDegrees,
        _ longitudeDelta: LocationDegrees
    ) {
        self.init(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    }
}
#endif

//
//  CLLocationCoordinate2D+ext.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import MapKit

#if DEBUG
extension CLLocationCoordinate2D {
    
    static let barcelona:    Self = .init(41.390205, 2.154007)
    static let london:       Self = .init(51.507222, -0.1275)
    static let paris:        Self = .init(48.8567, 2.3508)
    static let rome:         Self = .init(41.9, 12.5)
    static let washingtonDC: Self = .init(38.895111, -77.036667)
    
    private init(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
        self.init(latitude: latitude, longitude: longitude)
    }
}
#endif

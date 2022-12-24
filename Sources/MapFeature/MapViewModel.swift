//
//  MapViewModel.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import Foundation
import MapKit

public final class MapViewModel: ObservableObject {
    
    @Published var region: MKCoordinateRegion
    
    @Published private(set) var center: CLLocationCoordinate2D
    
    public init(
        initialRegion: MKCoordinateRegion
    ) {
        self.region = initialRegion
        self.center = initialRegion.center
        
        #warning("use schedulers")
        $region
            .map(\.center)
            .removeDuplicates { isClose($0, to: $1, withAccuracy: 0.0001) }
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .assign(to: &$center)
    }
}

/// - Warning: super simplified approach just to move on
/// see [Precision of coordinates - OpenStreetMap Wiki](https://wiki.openstreetmap.org/wiki/Precision_of_coordinates)
/// https://stackoverflow.com/a/39540339/11793043
/// [Universal Transverse Mercator coordinate system - Wikipedia](https://en.wikipedia.org/wiki/Universal_Transverse_Mercator_coordinate_system)
/// [Haversine formula - Wikipedia](https://en.wikipedia.org/wiki/Haversine_formula)
/// https://en.wikipedia.org/wiki/Geographic_coordinate_system#Latitude_and_longitude
///
func isClose(
    _ lhs: CLLocationCoordinate2D,
    to rhs: CLLocationCoordinate2D,
    withAccuracy accuracy: CLLocationDegrees = 0.0001
) -> Bool {
    abs(lhs.latitude.distance(to: rhs.latitude)) < accuracy
    && abs(lhs.longitude.distance(to: rhs.longitude)) < accuracy
}

//
//  MapViewModel.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import Combine
import CombineSchedulers
import Foundation
import MapKit

public final class MapViewModel: ObservableObject {
    
    public typealias GetStreetFrom = (CLLocationCoordinate2D) async -> String?
    
    @Published private(set) var region: MKCoordinateRegion
    @Published private(set) var street: String?
    
    public init(
        initialRegion: MKCoordinateRegion,
        getStreetFrom: @escaping GetStreetFrom,
        scheduler: AnySchedulerOf<DispatchQueue> = .main
    ) {
        self.region = initialRegion
        
        $region
            .map(\.center)
            .removeDuplicates { isClose($0, to: $1, withAccuracy: 0.0001) }
            .debounce(for: 0.5, scheduler: scheduler)
            .asyncMap(getStreetFrom)
            .receive(on: scheduler)
            .assign(to: &$street)
    }
    
    private var task: Task<Void, Never>?
    
    func update(region: MKCoordinateRegion) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.street = nil
            self.region = region
        }
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

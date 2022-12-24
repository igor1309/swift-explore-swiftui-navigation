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
    
    public init(region: MKCoordinateRegion) {
        self.region = region
    }
}

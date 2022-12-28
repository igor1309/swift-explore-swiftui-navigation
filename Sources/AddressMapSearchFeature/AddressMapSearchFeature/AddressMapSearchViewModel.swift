//
//  AddressMapSearchViewModel.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import Combine
import Foundation
import MapDomain

final class AddressMapSearchViewModel: ObservableObject {
    
    @Published private(set) var region: CoordinateRegion
    
    private let regionSearch = PassthroughSubject<CoordinateRegion, Never>()
    
    init(region: CoordinateRegion) {
        self.region = region
        
        regionSearch
            .map(\.center)
            .removeDuplicates { isClose($0, to: $1, withAccuracy: 0.0001) }
        // .. debounce, search, map, scheduler
    }
    
    /// The `setter` part of the `region` binding: update map region,
    /// but do not invoke search for the address.
    func update(region: CoordinateRegion) {
        self.region = region
    }
    
    /// The `setter` part of the `region` binding: update map region,
    /// and invoke search for the address at the center of the region.
    func updateAndSearch(region: CoordinateRegion) {
        update(region: region)
        regionSearch.send(region)
    }
}

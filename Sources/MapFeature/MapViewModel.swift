//
//  MapViewModel.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import Combine
import CombineSchedulers
import Foundation

public final class MapViewModel: ObservableObject {
    
    public typealias GetStreetFrom = (Coordinate) async -> String?
    
    @Published private(set) var region: CoordinateRegion
    @Published private(set) var streetState: StreetState
    
    public init(
        initialRegion: CoordinateRegion,
        getStreetFrom: @escaping GetStreetFrom,
        scheduler: AnySchedulerOf<DispatchQueue> = .main
    ) {
        self.region = initialRegion
        self.streetState = .none
        
        $region
            .map(\.center)
            .removeDuplicates { isClose($0, to: $1, withAccuracy: 0.0001) }
            .debounce(for: 0.5, scheduler: scheduler)
            .asyncMap(getStreetFrom)
            .map(StreetState.make(street:))
            .receive(on: scheduler)
            .assign(to: &$streetState)
    }
    
    func update(region: CoordinateRegion) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.streetState = .searching
            self.region = region
        }
    }
    
    enum StreetState: Equatable {
        case searching
        case none
        case street(String)
        
        static func make(street: String?) -> Self {
            guard let street else {
                return .none
            }
            
            return .street(street)
        }
    }
}

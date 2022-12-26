//
//  MapViewModel.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import CasePaths
import Combine
import CombineSchedulers
import Foundation
import MapDomain

public final class MapViewModel: ObservableObject {
    
    public typealias GetStreetFrom = (LocationCoordinate2D) async -> Address?
    
    @Published private(set) var region: CoordinateRegion
    @Published private(set) var addressState: AddressState
    
    public func streetPublisher() -> AnyPublisher<Address?, Never> {
        $addressState
            .map((/AddressState.address).extract(from:))
            .eraseToAnyPublisher()
    }
    
    public init(
        initialRegion: CoordinateRegion,
        getStreetFrom: @escaping GetStreetFrom,
        scheduler: AnySchedulerOf<DispatchQueue> = .main
    ) {
        self.region = initialRegion
        self.addressState = .none
        
        $region
            .map(\.center)
            .removeDuplicates { isClose($0, to: $1, withAccuracy: 0.0001) }
            .debounce(for: 0.5, scheduler: scheduler)
            .asyncMap(getStreetFrom)
            .map(AddressState.make(address:))
            .receive(on: scheduler)
            .assign(to: &$addressState)
    }
    
    var address: Address? {
        (/AddressState.address).extract(from: addressState)
    }    
    
    func update(region: CoordinateRegion) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.addressState = .searching
            self.region = region
        }
    }
    
    enum AddressState: Equatable {
        case searching
        case none
        case address(Address)
        
        static func make(address: Address?) -> Self {
            guard let address else {
                return .none
            }
            
            return .address(address)
        }
    }
}

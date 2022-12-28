//
//  AddressMapSearchViewModel.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import CasePaths
import Combine
import CombineSchedulers
import Foundation
import MapDomain

public final class AddressMapSearchViewModel: ObservableObject {
    
    @Published private(set) var region: CoordinateRegion
    @Published private(set) var addressState: AddressState
    
    private let regionSearch = PassthroughSubject<CoordinateRegion, Never>()
    
    public typealias AddressPublisher = AnyPublisher<Address?, Never>
    public typealias GetAddressFromCoordinate = (LocationCoordinate2D) -> AddressPublisher
    
    public init(
        initialRegion: CoordinateRegion,
        getAddressFromCoordinate: @escaping GetAddressFromCoordinate,
        scheduler: AnySchedulerOf<DispatchQueue> = .main
    ) {
        self.region = initialRegion
        self.addressState = .none
        
        regionSearch
            .map(\.center)
            .removeDuplicates { isClose($0, to: $1, withAccuracy: 0.0001) }
            .debounce(for: 0.5, scheduler: scheduler)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.addressState = .searching
            })
            .flatMap(getAddressFromCoordinate)
            .map(AddressState.make(address:))
            .receive(on: scheduler)
            .assign(to: &$addressState)
    }
    
    private let addressCasePath = /AddressState.address
    
    public var address: Address? {
        addressCasePath.extract(from: addressState)
    }
    
    public func addressPublisher() -> AnyPublisher<Address?, Never> {
        $addressState
            .map(addressCasePath.extract(from:))
            .eraseToAnyPublisher()
    }
    
    /// The `setter` part of the `region` binding: update map region,
    /// but do not invoke search for the address.
    public func update(region: CoordinateRegion) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.region = region
        }
    }
    
    /// The `setter` part of the `region` binding: update map region,
    /// and invoke search for the address at the center of the region.
    public func updateAndSearch(region: CoordinateRegion) {
        self.regionSearch.send(region)
        self.update(region: region)
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

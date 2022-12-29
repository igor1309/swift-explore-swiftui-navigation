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
    @Published private(set) var searchText: String = ""
    @Published private(set) var suggestions: Suggestions?
    
    let dismissSearch = PassthroughSubject<Void, Never>()
    
    private let regionSearch = PassthroughSubject<CoordinateRegion, Never>()
    private let completionSubject = PassthroughSubject<Completion, Never>()
    
    public typealias AddressPublisher = AnyPublisher<Address?, Never>
    public typealias GetAddressFromCoordinate = (LocationCoordinate2D) -> AddressPublisher
    
    public typealias CompletionsPublisher = AnyPublisher<[Completion], Never>
    public typealias GetCompletions = (String) -> CompletionsPublisher
    
    public typealias SearchPublisher = AnyPublisher<[Address], Never>
    public typealias Search = (Completion) -> SearchPublisher
    
    public init(
        initialRegion: CoordinateRegion,
        getAddressFromCoordinate: @escaping GetAddressFromCoordinate,
        getCompletions: @escaping GetCompletions,
        search: @escaping Search,
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
        
        Publishers.Merge(
            $searchText
                .removeDuplicates()
                .debounce(for: 0.5, scheduler: scheduler)
                .handleEvents(receiveOutput: {
                    print("$searchText pipeline:", String(describing: $0))
                })
                .flatMap(getCompletions)
                .map { .completions($0) },
            completionSubject
                .flatMap(search)
                .map { .addresses($0) }
        )
        .receive(on: scheduler)
        .assign(to: &$suggestions)
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
    
    /// The `setter` part of the `searchText` binding.
    func setSearchText(to text: String) {
        self.searchText = text
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
    
    func completionButtonTapped(completion: Completion) {
        self.completionSubject.send(completion)
    }
    
    func addressButtonTapped(address: Address) {
        // self.selectAddress.send(address)
        self.addressState = .address(address)
        #warning("need to position map! - so need to call `update(region:)` with region returned from API")
        self.suggestions = nil
        self.dismissSearch.send(())
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

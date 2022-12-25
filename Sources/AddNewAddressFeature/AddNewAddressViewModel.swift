//
//  AddNewAddressViewModel.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import Combine
import CombineSchedulers
import Foundation

public final class AddNewAddressViewModel: ObservableObject {
    
    public typealias AddressPublisher = AnyPublisher<Address?, Never>
    public typealias GetAddress = () -> AddressPublisher
    public typealias SuggestionsPublisher = AnyPublisher<[Suggestion], Never>
    public typealias GetSuggestions = (String) -> SuggestionsPublisher
    
    @Published private(set) var searchText: String = ""
    @Published private(set) var suggestions: [Suggestion] = []
    @Published private(set) var address: Address?
    
    private let getAddress: GetAddress
    private let addAddress: (String) -> Void
    
    let dismiss = PassthroughSubject<Void, Never>()
    
    private let selectAddress = PassthroughSubject<Address?, Never>()
    
    /// - Parameters:
    ///   - getAddress: A closure connected to map interactions.
    ///   - getSuggestions: Search completions.
    ///   - addAddress: Injected closure to handle selected/created address.
    ///   - scheduler: DispatchQueue Scheduler.
    public init(
        getAddress: @escaping GetAddress,
        getSuggestions: @escaping GetSuggestions,
        addAddress: @escaping (String) -> Void,
        scheduler: AnySchedulerOf<DispatchQueue> = .main
    ) {
        self.addAddress = addAddress
        self.getAddress = getAddress
        
        $searchText
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: scheduler)
            .flatMap(getSuggestions)
            .receive(on: scheduler)
            .assign(to: &$suggestions)
        
        getAddress()
            .merge(with: selectAddress)
            .receive(on: scheduler)
            .assign(to: &$address)
    }
    
    func setSearchText(to text: String) {
        self.searchText = text
    }
    
    func addAddressButtonTapped() {
        addAddress(searchText)
    }
    
    func select(_ suggestion: Suggestion) {
        selectAddress.send(suggestion.address)
        self.dismiss.send(())
    }
}

//
//  AddNewAddressViewModel.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import Combine
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
    private let getSuggestions: GetSuggestions
    private let addAddress: (String) -> Void
    
    let dismiss = PassthroughSubject<Void, Never>()
    
    private let selectAddress = PassthroughSubject<Address?, Never>()
    
    public init(
        getAddress: @escaping GetAddress,
        getSuggestions: @escaping GetSuggestions,
        addAddress: @escaping (String) -> Void
    ) {
        self.addAddress = addAddress
        self.getSuggestions = getSuggestions
        self.getAddress = getAddress
        
        $searchText
            .removeDuplicates()
        //.debounce(for: T##SchedulerTimeIntervalConvertible & Comparable & SignedNumeric, scheduler: T##Scheduler)
        //.receive(on: <#T##Scheduler#>)
            .flatMap(getSuggestions)
            .assign(to: &$suggestions)
        
        getAddress()
            .merge(with: selectAddress)
            //.receive(on: <#T##Scheduler#>)
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

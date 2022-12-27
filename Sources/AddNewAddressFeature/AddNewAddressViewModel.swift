//
//  AddNewAddressViewModel.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import CasePaths
import Combine
import CombineSchedulers
import Foundation

public final class AddNewAddressViewModel: ObservableObject {
    
    public typealias CompletionsPublisher = AnyPublisher<[Completion], Never>
    public typealias GetCompletions = (String) -> CompletionsPublisher
    
    public typealias AddressPublisher = AnyPublisher<Address?, Never>
    public typealias GetAddress = () -> AddressPublisher
    
    public typealias AddAddress = (Address) -> Void
    
    @Published private(set) var searchText: String = ""
    @Published private(set) var suggestions: Suggestions?
    @Published private(set) var address: Address?
    
    private let getAddress: GetAddress
    private let addAddress: AddAddress
    
    let dismiss = PassthroughSubject<Void, Never>()
    
    private let selectAddress = PassthroughSubject<Address?, Never>()
    #warning("add service to store previous searches / or just inject? / or move this responsibility up the chain to CompletionsPublisher as in AddNewAddressViewDemo")
    /// - Parameters:
    ///   - getAddress: A closure connected to map interactions.
    ///   - getCompletions: Search completions. Also responsible for (optionally) providing previous search queries to be displayed on search field activation (search field is active but still empty).
    ///   - addAddress: Injected closure to handle selected/created address.
    ///   - scheduler: DispatchQueue Scheduler.
    public init(
        getAddress: @escaping GetAddress,
        getCompletions: @escaping GetCompletions,
        addAddress: @escaping AddAddress,
        scheduler: AnySchedulerOf<DispatchQueue> = .main
    ) {
        self.addAddress = addAddress
        self.getAddress = getAddress
        
        $searchText
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: scheduler)
            .flatMap(getCompletions)
            .receive(on: scheduler)
            .map{ .completions($0) }
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
        guard let address,
              !address.street.isEmpty
        else {
            return
        }
                          
        addAddress(address)
    }
    
    var addAddressButtonIsDisabled: Bool {
        guard let address,
              !address.street.isEmpty
        else {
            return true
        }
        
        return false
    }
    
    func completionButtonTapped(completion: Completion) {
        #warning("finish this")
    }
    
    func addressButtonTapped(address: Address) {
        #warning("finish this")
    }
    
    #warning("fix this")
    func select(_ suggestion: Suggestions) {
        // selectAddress.send(suggestion.address)
        self.dismiss.send(())
    }
}

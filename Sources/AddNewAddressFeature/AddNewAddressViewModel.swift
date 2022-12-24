//
//  AddNewAddressViewModel.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import Foundation

public final class AddNewAddressViewModel: ObservableObject {
    
    public typealias GetSuggestions = (String) -> [Suggestion]
    
    @Published private(set) var searchText: String = ""
    @Published private(set) var suggestions: [Suggestion] = []
    @Published private(set) var address: Address?
    
    private let getAddress: () -> Void
    private let addAddress: (String) -> Void
    private let getSuggestions: GetSuggestions
    
    public init(
        getAddress: @escaping () -> Void,
        addAddress: @escaping (String) -> Void,
        getSuggestions: @escaping GetSuggestions
    ) {
        self.addAddress = addAddress
        self.getAddress = getAddress
        self.getSuggestions = getSuggestions
        
        $searchText
            .removeDuplicates()
        //.debounce(for: <#T##SchedulerTimeIntervalConvertible & Comparable & SignedNumeric#>, scheduler: <#T##Scheduler#>)
            .map(getSuggestions)
            .assign(to: &$suggestions)
    }
    
    func setSearchText(to text: String) {
        self.searchText = text
    }
    
    func addAddressButtonTapped() {
        addAddress(searchText)
    }
    
    func select(_ suggestion: Suggestion) {
        self.address = suggestion.address
        #warning("dismiss search")
    }
}

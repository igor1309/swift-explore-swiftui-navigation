//
//  AddressMapSearchState.swift
//  
//
//  Created by Igor Malyarov on 30.12.2022.
//

import MapDomain

public struct AddressMapSearchState: Equatable {
    
    /// A region that corresponds to an area to display on the map.
    public var region: CoordinateRegion
    
    /// A search state.
    public var search: Search?
    
    /// A state of address.
    public var addressState: AddressState?
    
    public init(
        region: CoordinateRegion,
        search: Search? = nil,
        addressState: AddressState? = nil
    ) {
        self.region = region
        self.search = search
        self.addressState = addressState
    }
    
    public struct Search: Equatable {
        
        /// The text to display and edit in the search field.
        public var searchText: String
        
        public var suggestions: Suggestions?
        
        public init(searchText: String = "", suggestions: Suggestions? = nil) {
            self.searchText = searchText
            self.suggestions = suggestions
        }
    }
    
    public enum AddressState: Equatable {
        case searching
        case address(Address)
    }
    
    public enum Suggestions: Equatable {
        case completions([Completion])
        case searchItems([SearchItem])
    }
}

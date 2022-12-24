//
//  AddNewAddressViewModel.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import Foundation

public final class AddNewAddressViewModel: ObservableObject {
    
    @Published private(set) var searchText: String = ""
    
    private let getAddress: () -> Void
    private let addAddress: (String) -> Void
    
    public init(
        getAddress: @escaping () -> Void,
        addAddress: @escaping (String) -> Void
    ) {
        self.addAddress = addAddress
        self.getAddress = getAddress
    }
    
    func setSearchText(to text: String) {
        self.searchText = text
    }
    
    func addAddressButtonTapped() {
        addAddress(searchText)
    }
}

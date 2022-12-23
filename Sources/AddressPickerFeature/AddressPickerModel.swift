//
//  AddressPickerModel.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Domain
import Foundation

public final class AddressPickerModel: ObservableObject {

    @Published private(set) var route: Route?

    let address: Address?
    let addresses: Addresses
    
    let selectAddress: (Address) -> Void
    let addNewAddressAction: () -> Void

    public init(
        address: Address?,
        addresses: Addresses,
        route: Route? = nil,
        selectAddress: @escaping (Address) -> Void,
        addNewAddressAction: @escaping () -> Void
    ) {
        self.route = route
        self.address = address
        self.addresses = addresses
        self.selectAddress = selectAddress
        self.addNewAddressAction = addNewAddressAction
    }

    func isSelected(_ address: Address) -> Bool {
        self.address == address
    }
    
    public func navigate(to route: Route?) {
        self.route = route
    }
    
    public enum Route: Identifiable {
        case newAddress
        
        public var id: Self { self }
    }
}

extension AddressPickerModel: Hashable {
    
    public static func == (lhs: AddressPickerModel, rhs: AddressPickerModel) -> Bool {
        lhs === rhs
    }
    
    public func hash (into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

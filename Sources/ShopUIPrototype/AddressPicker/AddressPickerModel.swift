//
//  AddressPickerModel.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation

public final class AddressPickerModel: ObservableObject {

    @Published var route: Route?
    
    private let profile: Profile
    
    let selectAddress: (Address) -> Void
    let addAddressAction: () -> Void

    public init(
        route: Route? = nil,
        profile: Profile,
        selectAddress: @escaping (Address) -> Void,
        addAddressAction: @escaping () -> Void
    ) {
        self.route = route
        self.profile = profile
        self.selectAddress = selectAddress
        self.addAddressAction = addAddressAction
    }
    
    var address: Address? {
        profile.address
    }
    
    var addresses: Addresses {
        profile.addresses
    }
    
    func isSelected(_ address: Address) -> Bool {
        profile.address == address
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

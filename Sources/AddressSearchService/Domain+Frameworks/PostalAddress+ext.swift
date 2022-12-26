//
//  PostalAddress+ext.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import Contacts

extension PostalAddress: RawRepresentable {
    
    public var rawValue: CNPostalAddress {
        let cnMutablePostalAddress = CNMutablePostalAddress()
        cnMutablePostalAddress.street = street
        cnMutablePostalAddress.city = city
        return cnMutablePostalAddress
    }
    
    public init(rawValue: CNPostalAddress) {
        self.init(street: rawValue.street, city: rawValue.city)
    }
}

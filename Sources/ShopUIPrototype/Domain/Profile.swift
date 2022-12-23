//
//  Profile.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation
import Tagged

public struct Profile: Hashable, Identifiable {
    
    public typealias ID = Tagged<Self, UUID>
    
    public let id: ID
    
    var name: String
    var email: Email
    var phone: Phone
    
    public var address: Address?
    public var addresses: Addresses
    
    public init(
        id: ID = .init(),
        name: String,
        email: Email,
        phone: Phone,
        address: Address? = nil,
        addresses: Addresses
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address
        self.addresses = addresses
    }
}

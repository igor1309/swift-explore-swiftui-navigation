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
    
    public var address: Address?
    public var addresses: Addresses
    
    public init(
        id: ID = .init(),
        address: Address? = nil,
        addresses: Addresses = []
    ) {
        self.id = id
        self.address = address
        self.addresses = addresses
    }
}

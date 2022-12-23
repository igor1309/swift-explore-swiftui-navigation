//
//  Address.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation
import Tagged

public struct Address: Hashable, Identifiable {
    
    public typealias ID = Tagged<Self, UUID>
    public typealias Street = Tagged<StreetType, String>
    
    public let id: ID
    public let street: Street
    
    public init(
        id: ID = .init(),
        street: Street
    ) {
        self.id = id
        self.street = street
    }
}

public extension Address {
    
    enum StreetType {}
}

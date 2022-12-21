//
//  Address.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation
import Tagged

public struct Address: Hashable, Identifiable {
    
    public let id: Tagged<Self, UUID>
    public let street: Tagged<Street, String>
    
    public init(
        id: Tagged<Self, UUID> = .init(),
        street: Tagged<Street, String>
    ) {
        self.id = id
        self.street = street
    }
}

public extension Address {
    
    enum Street {}
}

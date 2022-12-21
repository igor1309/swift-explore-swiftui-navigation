//
//  Profile.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation
import Tagged

public struct Profile: Hashable, Identifiable {
    
    public let id: Tagged<Self, UUID>
    public let address: Address
    
    public init(
        id: Tagged<Self, UUID> = .init(),
        address: Address
    ) {
        self.id = id
        self.address = address
    }
}

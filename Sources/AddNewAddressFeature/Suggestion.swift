//
//  Suggestion.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import Foundation
import Tagged

public struct Suggestion: Identifiable {
    
    public typealias ID = Tagged<Self, UUID>
    
    public let id: ID
    public let address: Address
    
    public init(id: ID = .init(), address: Address) {
        self.id = id
        self.address = address
    }
}

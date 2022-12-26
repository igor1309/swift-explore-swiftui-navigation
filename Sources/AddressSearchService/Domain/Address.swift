//
//  Address.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import Foundation

public struct Address: Equatable {
    
    public let street: String
    public let city: String
    
    public init(street: String, city: String) {
        self.street = street
        self.city = city
    }
}

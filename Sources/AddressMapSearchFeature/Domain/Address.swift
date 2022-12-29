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
    public typealias City = Tagged<CityType, String>

    public let id: ID
    public let street: Street
    public let city: City

    public init(
        id: ID = .init(),
        street: Street,
        city: City
    ) {
        self.id = id
        self.street = street
        self.city = city
    }
}

public extension Address {
    
    enum StreetType {}
    enum CityType {}
}

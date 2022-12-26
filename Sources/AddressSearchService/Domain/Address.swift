//
//  Address.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

public struct Address: Equatable {
    
    /// The street name in a postal address.
    public var street: String
    
    /// The city name in a postal address.
    public var city: String

    public init(street: String, city: String) {
        self.street = street
        self.city = city
    }
}

extension Address {
    
    init(mapItem: MapItem) {
        self.init(
            street: mapItem.address.street,
            city: mapItem.address.city
        )
    }
}

extension Array where Element == Address {
    
    init(_ response: LocalSearchClient.Response) {
        self = response.mapItems.compactMap(Address.init(mapItem:))
    }
}
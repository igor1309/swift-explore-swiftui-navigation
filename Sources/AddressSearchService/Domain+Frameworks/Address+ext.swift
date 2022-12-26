//
//  Address+ext.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import MapKit

extension Address {
    
    init(mapItem: MapItem) {
        self.init(
            street: mapItem.postalAddress.street,
            city: mapItem.postalAddress.city
        )
    }
}

extension Array where Element == Address {
    
    init(_ response: LocalSearchClient.Response) {
        self = response.mapItems.compactMap(Address.init(mapItem:))
    }
}


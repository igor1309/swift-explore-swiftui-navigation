//
//  SearchItem.swift
//  
//
//  Created by Igor Malyarov on 30.12.2022.
//

import Foundation
import MapDomain
import Tagged

public struct SearchItem: Equatable, Identifiable {
    
    public typealias ID = Tagged<Self, UUID>
    
    public let id: ID
    public let address: Address
    public let region: CoordinateRegion
    
    public init(id: ID = .init(), address: Address, region: CoordinateRegion) {
        self.id = id
        self.address = address
        self.region = region
    }
}

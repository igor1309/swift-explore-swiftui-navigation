//
//  Shop.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation
import Tagged

public struct Shop: Hashable, Identifiable {
    
    public typealias ID = Tagged<Self, UUID>
    
    public let id: ID
    public let title: String
    public let shopType: ShopType
    
    public init(
        id: ID = .init(),
        title: String,
        shopType: ShopType
    ) {
        self.id = id
        self.title = title
        self.shopType = shopType
    }
}

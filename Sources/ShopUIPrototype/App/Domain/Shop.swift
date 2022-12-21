//
//  Shop.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation
import Tagged

public struct Shop: Hashable, Identifiable {
    
    public let id: Tagged<Self, UUID>
    public let title: String
    public let shopType: ShopType
    
    public init(
        id: Tagged<Self, UUID> = .init(),
        title: String,
        shopType: ShopType
    ) {
        self.id = id
        self.title = title
        self.shopType = shopType
    }
}

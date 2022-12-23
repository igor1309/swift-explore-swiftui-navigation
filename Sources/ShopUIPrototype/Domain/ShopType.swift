//
//  ShopType.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation
import Tagged

public struct ShopType: Hashable, Identifiable {
    
    public typealias ID = Tagged<Self, UUID>
    
    public let id: ID
    public let title: String
    
    public init(
        id: ID = .init(),
        title: String
    ) {
        self.id = id
        self.title = title
    }
}

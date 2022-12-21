//
//  Product.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation
import Tagged

public struct Product: Hashable, Identifiable {
    
    public typealias ID = Tagged<Self, UUID>
    
    public let id: ID
    public let title: String
    public let category: Category
    
    public init(
        id: ID = .init(),
        title: String,
        category: Category
    ) {
        self.id = id
        self.title = title
        self.category = category
    }
}

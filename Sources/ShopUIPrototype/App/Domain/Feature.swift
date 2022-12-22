//
//  Feature.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation
import Tagged

public struct Feature: Hashable, Identifiable {
 
    public typealias ID = Tagged<Self, UUID>
    
    public let id: ID
    
    public init(id: ID = .init()) {
        self.id = id
    }
}

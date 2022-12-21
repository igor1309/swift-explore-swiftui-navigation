//
//  Feature.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation
import Tagged

public struct Feature: Hashable, Identifiable {
    public let id: Tagged<Self, UUID>
    
    public init(id: Tagged<Self, UUID> = .init()) {
        self.id = id
    }
}

//
//  DeliveryType.swift
//  
//
//  Created by Igor Malyarov on 23.12.2022.
//

public enum DeliveryType: String, CaseIterable, Identifiable {
    case all, fast, `self`
    
    public var id: Self { self }
}

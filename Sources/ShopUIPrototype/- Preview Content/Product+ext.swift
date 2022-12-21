//
//  Product+ext.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

#if DEBUG
public extension Product {
    static let preview: Self = .init(title: "Milk", category: .grocery)
}
#endif

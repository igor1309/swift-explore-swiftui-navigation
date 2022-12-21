//
//  Category+ext.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

#if DEBUG
public extension Category {
    
    static let preview: Self = .grocery
    static let grocery: Self = .init(title: "Grocery")
}
#endif

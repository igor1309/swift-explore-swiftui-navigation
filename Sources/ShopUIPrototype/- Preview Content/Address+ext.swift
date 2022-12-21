//
//  Address+ext.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

#if DEBUG
public extension Address {
    
    static let preview: Self = .init(
        id: .init(),
        street: .init("Some Street, 123")
    )
    static let second: Self = .init(
        id: .init(),
        street: .init("Second Avenue, 45")
    )
}
#endif

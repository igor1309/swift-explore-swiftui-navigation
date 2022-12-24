//
//  Array+ext.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import Foundation

#if DEBUG
extension Array where Element == Address {
    
    static let prevSearches: Self = [
        .init(street: .init("5th Ave, 123")),
    ]
    static let preview: Self = [
        .init(street: .init("Black Street, 123")),
        .init(street: .init("White Avenue, 456"))
    ]
}

extension Array where Element == Suggestion {
    
    static let prevSearches: Self = [Address].prevSearches.map {
        .init(address: $0)
    }
    static let preview: Self = [Address].preview.map {
        .init(address: $0)
    }
}
#endif

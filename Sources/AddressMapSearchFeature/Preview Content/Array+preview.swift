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
        .init(street: .init("5th Ave, 123"), city: "NCity"),
    ]
    static let preview: Self = [
        .init(street: .init("Black Street, 123"), city: "MCity"),
        .init(street: .init("White Avenue, 456"), city: "QCity")
    ]
}

extension Array where Element == Completion {
    
    static let prevSearches: Self = [.prevSearch1, .prevSearch2, .prevSearch3]
    static let preview: Self = [.preview, .fake1, .fake2]
}
#endif

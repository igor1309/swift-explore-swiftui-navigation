//
//  Address+preview.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import Foundation

#if DEBUG
extension Address {
    
    static let preview: Self = .init(
        street: "Preview Street, 123",
        city: "PCity"
    )
    static let another: Self = .init(
        street: "Another Street, 123",
        city: "ACity"
    )
}
#endif

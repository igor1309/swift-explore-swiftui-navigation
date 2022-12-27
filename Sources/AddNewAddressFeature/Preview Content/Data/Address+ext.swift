//
//  Address+ext.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import Foundation

#if DEBUG
extension Address {
    
    static let preview: Self = .init(
        street: .init("Review Street, 0123"),
        city: "NCity"
    )
}
#endif

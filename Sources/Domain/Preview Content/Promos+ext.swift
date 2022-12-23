//
//  Promo+ext.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import IdentifiedCollections

#if DEBUG
public extension Promos {
    
    static let preview: Self = .init(uniqueElements: [Promo].preview)
}

private extension Array where Element == Promo {
    
    static let preview: Self = [
        .init(), .init(), .init(), .init(), .init(), .init()
    ]
}
#endif

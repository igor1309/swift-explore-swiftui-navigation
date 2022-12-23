//
//  ShopTypes+ext.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import IdentifiedCollections

#if DEBUG
public extension ShopTypes {
    
    static let preview: Self = .init(uniqueElements: [ShopType].preview)
}

private extension Array where Element == ShopType {
    
    static let preview: Self = [.farmacy, .alcohol, .hyper, .house, .zoo, .market, .flower, .extraordinary, .gadgets, .stationary]
}
#endif

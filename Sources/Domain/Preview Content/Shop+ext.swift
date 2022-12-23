//
//  Shop+ext.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

#if DEBUG
public extension Shop {
    
    static let preview: Self = .init(
        title: "Mr. Bouquet",
        shopType: .preview
    )
}
#endif

//
//  Profile+ext.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

#if DEBUG
public extension Profile {
    
    static let preview: Self = .init(
        address: .preview,
        addresses: [.preview, .second]
    )
    static let noAddresses: Self = .init()
}
#endif

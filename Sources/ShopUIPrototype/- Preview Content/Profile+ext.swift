//
//  Profile+ext.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

#if DEBUG
public extension Profile {
    
    static let preview: Self = .init(
        name: "John Smith",
        email: "john@smith.com",
        phone: "+0-123-456-789",
        address: .preview,
        addresses: [.preview, .second]
    )
    static let noAddresses: Self = .init(
        name: "Mary Smith",
        email: "mary@smith.com",
        phone: "+9-876-543-210",
        addresses: []
    )
}
#endif

//
//  Feature+ext.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

#if DEBUG
public extension Feature {
    static let preview: Self = .init(id: .init())
}
#endif

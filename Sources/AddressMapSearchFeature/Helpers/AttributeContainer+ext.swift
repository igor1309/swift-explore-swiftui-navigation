//
//  AttributeContainer+ext.swift
//  SearchableMap
//
//  Created by Igor Malyarov on 23.10.2022.
//

import Foundation

extension AttributeContainer {
    
    static let primary: Self = .init().foregroundColor(.primary)
    static let red: Self = .init().foregroundColor(.red)
    static let mint: Self = .init().foregroundColor(.mint)
    static let underlined: Self = .init().underlineStyle(.single)
    static let underlinedRed: Self = .init().underlineStyle(.single).foregroundColor(.red)
}

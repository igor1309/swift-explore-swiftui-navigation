//
//  Category.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation
import Tagged

struct Category: Hashable, Identifiable {
    let id: Tagged<Self, UUID>
}

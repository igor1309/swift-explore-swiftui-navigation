//
//  File.swift
//  
//
//  Created by Igor Malyarov on 22.12.2022.
//

import Foundation

public final class AppViewModel: ObservableObject {
    
    public let profile: Profile
    public let shopTypes: ShopTypes
    public let promos: Promos
    public let shops: Shops
    
    public init(
        profile: Profile,
        shopTypes: ShopTypes,
        promos: Promos,
        shops: Shops
    ) {
        self.profile = profile
        self.shopTypes = shopTypes
        self.promos = promos
        self.shops = shops
    }
}

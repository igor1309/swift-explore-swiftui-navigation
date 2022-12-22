//
//  File.swift
//  
//
//  Created by Igor Malyarov on 22.12.2022.
//

import Foundation

public final class AppViewModel: ObservableObject {
    
    @Published private(set) var profile: Profile
    @Published private(set) var shopTypes: ShopTypes
    @Published private(set) var promos: Promos
    @Published private(set) var shops: Shops
    
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
    
    func setAddress(to address: Address) {
        profile.address = address
    }
    
    func updateProfile(
        name: String,
        email: Email,
        phone: Phone
    ) {
        profile.name = name
        profile.email = email
        profile.phone = phone
    }
}

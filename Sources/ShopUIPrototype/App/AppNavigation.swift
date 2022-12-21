//
//  AppNavigation.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation
import Tagged

final class AppNavigation: ObservableObject {
    
    @Published var route: Route?
    
    init(route: Route? = nil) {
        self.route = route
    }
}

extension AppNavigation {
    
    func showProfileButtonTapped(profile: Profile) {
        route = .profile(profile)
    }
}

extension AppNavigation {
    
    enum Route: Hashable {
        
        case address(Address)
        case category(Category)
        case featuredShop(Shop)
        case newFeature(Feature)
        case promo(Promo)
        case shop(Shop)
        case profile(Profile)
    }
}

extension AppNavigation.Route: Identifiable {
    
    var id: Tagged<Self, UUID> {
        switch self {
        case let .address(address):
            return .init(rawValue: address.id.rawValue)
        case let .category(category):
            return .init(rawValue: category.id.rawValue)
        case let .featuredShop(shop):
            return .init(rawValue: shop.id.rawValue)
        case let .newFeature(feature):
            return .init(rawValue: feature.id.rawValue)
        case let .promo(promo):
            return .init(rawValue: promo.id.rawValue)
        case let .shop(shop):
            return .init(rawValue: shop.id.rawValue)
        case let .profile(profile):
            return .init(rawValue: profile.id.rawValue)
        }
    }
}

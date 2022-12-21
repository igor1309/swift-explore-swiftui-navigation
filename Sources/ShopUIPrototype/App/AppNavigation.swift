//
//  AppNavigation.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation

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
    
#warning("replace with tagged")
    var id: UUID {
        switch self {
        case let .address(address):
            return address.id
        case let .category(category):
            return category.id
        case let .featuredShop(shop):
            return shop.id
        case let .newFeature(feature):
            return feature.id
        case let .promo(promo):
            return promo.id
        case let .shop(shop):
            return shop.id
        case let .profile(profile):
            return profile.id
        }
    }
}

struct Address: Hashable, Identifiable {
    #warning("replace with tagged")
    let id: UUID
}

struct Category: Hashable, Identifiable {
    #warning("replace with tagged")
    let id: UUID
}

struct Shop: Hashable, Identifiable {
    #warning("replace with tagged")
    let id: UUID
}

struct Feature: Hashable, Identifiable {
    #warning("replace with tagged")
    let id: UUID
}

struct Promo: Hashable, Identifiable {
    #warning("replace with tagged")
    let id: UUID
}

struct Profile: Hashable, Identifiable {
    #warning("replace with tagged")
    let id: UUID
}

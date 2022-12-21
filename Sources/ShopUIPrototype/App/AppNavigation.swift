//
//  AppNavigation.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation
import Tagged

public final class AppNavigation: ObservableObject {
    #warning("add `private(set)` to route")
    @Published var route: Route?
    
    public init(route: Route? = nil) {
        self.route = route
    }
}

extension AppNavigation {
    
    public func showProfileButtonTapped(profile: Profile) {
        route = .profile(profile)
    }
    
    public func addNewAddressButtonTapped(profile: Profile) {
        route = .newAddress(profile)
    }
}

extension AppNavigation {
    
    public enum Route: Hashable {
        
        case addressPicker(Profile, AddressPickerModel.Route? = nil)
        #warning("move to Address/Profile module/model")
        case newAddress(Profile)
        case category(Category)
        case featuredShop(Shop)
        case newFeature(Feature)
        case promo(Promo)
        case shop(Shop)
        case profile(Profile)
    }
}

extension AppNavigation.Route: Identifiable {
    
    public var id: Tagged<Self, UUID> {
        switch self {
        case let .addressPicker(profile, _):
            return .init(rawValue: profile.id.rawValue)
        case let .newAddress(profile):
            return .init(rawValue: profile.id.rawValue)
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

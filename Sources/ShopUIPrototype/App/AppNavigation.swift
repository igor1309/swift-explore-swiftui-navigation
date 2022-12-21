//
//  AppNavigation.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation
import Tagged

public final class AppNavigation: ObservableObject {
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
        route = .addressPicker(.newAddress)
    }
}

extension AppNavigation {
    
    public enum Route: Hashable {
        case addressPicker(AddressPickerModel.Route? = nil)
        case shopType(ShopType)
        case featuredShop(Shop)
        case newFeature(Feature)
        case promo(Promo)
        case shop(Shop)
        case profile(Profile)
    }
}

extension AppNavigation.Route: Identifiable {
    public var id: Self { self }
}

//
//  AppNavigation.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation
import Tagged

public final class AppNavigation: ObservableObject {
    
    @Published private(set) var route: Route?
    @Published private(set) var sheet: Sheet?
    
    public init(route: Route? = nil, sheetRoute: Sheet? = nil) {
        self.route = route
        self.sheet = sheetRoute
    }
}

extension AppNavigation {
    
    public func navigate(to route: Route?) {
        self.route = route
    }
    
    public func navigate(to sheet: Sheet?) {
        self.sheet = sheet
    }
    
    public func showProfileButtonTapped(profile: Profile) {
        sheet = .profile(.init(profile: profile))
    }
    
    public func addNewAddressButtonTapped(profile: Profile) {
        sheet = .addressPicker(.newAddress)
    }
}

extension AppNavigation {
    
    public enum Sheet: Hashable, Identifiable {
        case addressPicker(AddressPickerModel.Route? = nil)
        case profile(ProfileViewModel)
        
        public var id: Self { self }
    }
    
    public enum Route: Hashable, Identifiable {
        case shopType(ShopType)
        case featuredShop(Shop)
        case newFeature(Feature)
        case promo(Promo)
        case shop(ShopViewModel)
        
        public var id: Self { self }
    }
}

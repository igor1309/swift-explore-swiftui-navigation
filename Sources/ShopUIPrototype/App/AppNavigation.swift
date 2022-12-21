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
    @Published var sheet: Sheet?
    
    public init(route: Route? = nil, sheetRoute: Sheet? = nil) {
        self.route = route
        self.sheet = sheetRoute
    }
}

extension AppNavigation {
    
    public func showProfileButtonTapped(profile: Profile) {
        sheet = .profile(profile)
    }
    
    public func addNewAddressButtonTapped(profile: Profile) {
        sheet = .addressPicker(.newAddress)
    }
}

extension AppNavigation {
    
    public enum Sheet: Hashable, Identifiable {
        case addressPicker(AddressPickerModel.Route? = nil)
        case profile(Profile)
        
        public var id: Self { self }
    }
    
    public enum Route: Hashable, Identifiable {
        case shopType(ShopType)
        case featuredShop(Shop)
        case newFeature(Feature)
        case promo(Promo)
        case shop(Shop, ShopViewModel.Route? = nil)
        
        public var id: Self { self }
    }
}

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
    @Published var sheetRoute: SheetRoute?
    
    public init(route: Route? = nil, sheetRoute: SheetRoute? = nil) {
        self.route = route
        self.sheetRoute = sheetRoute
    }
}

extension AppNavigation {
    
    public func showProfileButtonTapped(profile: Profile) {
        sheetRoute = .profile(profile)
    }
    
    public func addNewAddressButtonTapped(profile: Profile) {
        sheetRoute = .addressPicker(.newAddress)
    }
}

extension AppNavigation {
    
    public enum SheetRoute: Hashable, Identifiable {
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

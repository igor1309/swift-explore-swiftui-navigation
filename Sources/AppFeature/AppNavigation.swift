//
//  AppNavigation.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import AddressPickerFeature
import Domain
import Foundation
import ProfileFeature
import ShopFeature
import Tagged

public final class AppNavigation: ObservableObject {

    @Published private(set) var route: Route?
    
    public init(route: Route? = nil) {
        self.route = route
    }
}

extension AppNavigation {
    
    public func navigate(to route: Route?) {
        self.route = route
    }
    
    public func navigate(to sheet: Route.Sheet) {
        navigate(to: .sheet(sheet))
    }
    
    public func navigate(to navigation: Route.Navigation) {
        navigate(to: .navigation(navigation))
    }
    
    public func showProfileButtonTapped(profile: Profile) {
        navigate(to: .profile(.init(profile: profile)))
    }
    
    public func addNewAddressButtonTapped(profile: Profile) {
        navigate(to: .addressPicker(.newAddress))
    }
}

extension AppNavigation {
    
    public enum Route: Hashable, Identifiable {
        
        case navigation(Navigation)
        case sheet(Sheet)
        
        public var id: Self { self }
        
        public enum Sheet: Hashable, Identifiable {
            case addressPicker(AddressPickerModel.Route? = nil)
            case profile(ProfileViewModel)
            
            public var id: Self { self }
        }
        
        public enum Navigation: Hashable, Identifiable {
            case shopType(ShopType)
            case featuredShop(Shop)
            case newFeature(Feature)
            case promo(Promo)
            case shop(ShopViewModel)
            
            public var id: Self { self }
        }
    }
}

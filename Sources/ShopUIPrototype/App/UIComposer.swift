//
//  UIComposer.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI

final class UIComposer {
    
    private let navigation: AppNavigation
    
    init(navigation: AppNavigation) {
        self.navigation = navigation
    }
}

// MARK: - Main Page Components

extension UIComposer {
    
    func makeAddressView() -> some View {
        TBD("Address View with edit Button")
    }
    
    func makeDeliveryTypePicker() -> some View {
        TBD("Delivery Type Picker: All/Quick/Self")
    }
    
    func makeCategoryStrip() -> some View {
        TBD("Category Strip: horizontal scroll")
    }
    
    func makeFeaturedShopsView() -> some View {
        TBD("Featured Shops View: small grid of 2")
    }
    
    func makeNewFeatureView() -> some View {
        TBD("New Feature View: promo")
    }
    
    func makePromoStrip() -> some View {
        TBD("Promo Strip")
    }
    
    func makeShopGridView() -> some View {
        TBD("Shop Grid View")
    }
    
    func makeShowProfileButton(profile: Profile) -> some View {
        Button { [weak self] in
            self?.navigation.showProfileButtonTapped(profile: profile)
        } label: {
            Label("Shop Grid View", systemImage: "person.circle")
        }
    }
}

// MARK: - Destination Components

extension UIComposer {
    
    func makeAddressEditorView(for address: Address) -> some View {
        Text("Address Editor")
    }
    
    func makeCategoryView(for category: Category) -> some View {
        Text("Category View")
    }
    
    func makeShopView(for shop: Shop) -> some View {
        Text("Shop View")
    }
    
    func makeFeatureView(for feature: Feature) -> some View {
        Text("Feature View")
    }
    
    func makePromoView(for promo: Promo) -> some View {
        Text("Promo View")
    }
    
    func makeProfileView(for profile: Profile) -> some View {
        Text("Profile View")
    }
    
    @ViewBuilder
    func destination(route: AppNavigation.Route) -> some View {
        switch route {
        case let .address(address):
            makeAddressEditorView(for: address)
        
        case let .category(category):
            makeCategoryView(for: category)
        
        case let .featuredShop(shop):
            makeShopView(for: shop)
            
        case let .newFeature(feature):
            makeFeatureView(for: feature)
        
        case let .promo(promo):
            makePromoView(for: promo)
        
        case let .shop(shop):
            makeShopView(for: shop)
        
        case let .profile(profile):
            makeProfileView(for: profile)
        }
    }
}

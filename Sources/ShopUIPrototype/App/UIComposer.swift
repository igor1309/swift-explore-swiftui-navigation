//
//  UIComposer.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI

public final class UIComposer {
    
    let navigation: AppNavigation
    
    public init(navigation: AppNavigation) {
        self.navigation = navigation
    }
}

// MARK: - Main Page Components

extension UIComposer {
    
    public func makeAddressView() -> some View {
        TBD("Address View with edit Button")
    }
    
    public func makeDeliveryTypePicker() -> some View {
        TBD("Delivery Type Picker: All/Quick/Self")
    }
    
    public func makeCategoryStrip() -> some View {
        TBD("Category Strip: horizontal scroll")
    }
    
    public func makeFeaturedShopsView() -> some View {
        TBD("Featured Shops View: small grid of 2")
    }
    
    public func makeNewFeatureView() -> some View {
        TBD("New Feature View: promo")
    }
    
    public func makePromoStrip() -> some View {
        TBD("Promo Strip")
    }
    
    public func makeShopGridView() -> some View {
        TBD("Shop Grid View")
    }
    
    public func makeShowProfileButton(profile: Profile) -> some View {
        Button { [weak self] in
            self?.navigation.showProfileButtonTapped(profile: profile)
        } label: {
            Label("Shop Grid View", systemImage: "person.circle")
        }
    }
}

// MARK: - Destination Components

extension UIComposer {
    
    public func makeAddressEditorView(for address: Address) -> some View {
        Text("Address Editor")
    }
    
    public func makeCategoryView(for category: Category) -> some View {
        Text("Category View")
    }
    
    public func makeShopView(for shop: Shop) -> some View {
        Text("Shop View")
    }
    
    public func makeFeatureView(for feature: Feature) -> some View {
        Text("Feature View")
    }
    
    public func makePromoView(for promo: Promo) -> some View {
        Text("Promo View")
    }
    
    public func makeProfileView(for profile: Profile) -> some View {
        Text("Profile View")
    }
    
    @ViewBuilder
    public func destination(route: AppNavigation.Route) -> some View {
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

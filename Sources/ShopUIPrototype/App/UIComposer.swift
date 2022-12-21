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
        AddressView()
    }
    
    public func makeDeliveryTypePicker() -> some View {
        DeliveryTypePicker()
    }
    
    public func makeCategoryStrip() -> some View {
        CategoryStrip()
    }
    
    public func makeFeaturedShopsView() -> some View {
        FeaturedShopsView()
    }
    
    public func makeNewFeatureView() -> some View {
        NewFeatureView()
    }
    
    public func makePromoStrip() -> some View {
        PromoStrip()
    }
    
    public func makeShopGridView() -> some View {
        ShopGridView()
    }
    
    public func makeShowProfileButton(profile: Profile) -> some View {
        ShowProfileButton(profile: profile) { [weak self] in
            self?.navigation.showProfileButtonTapped(profile: profile)
        }
    }
}

// MARK: - Destination Components

extension UIComposer {
    
    public func makeAddressEditorView(for address: Address) -> some View {
        AddressEditorView()
    }
    
    public func makeCategoryView(for category: Category) -> some View {
        CategoryView()
    }
    
    public func makeShopView(for shop: Shop) -> some View {
        ShopView()
    }
    
    public func makeFeatureView(for feature: Feature) -> some View {
        FeatureView()
    }
    
    public func makePromoView(for promo: Promo) -> some View {
        PromoView()
    }
    
    public func makeProfileView(for profile: Profile) -> some View {
        ProfileView()
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

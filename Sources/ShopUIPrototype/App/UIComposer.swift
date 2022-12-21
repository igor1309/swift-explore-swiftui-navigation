//
//  UIComposer.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI

public final class UIComposer {
    
    let navigation: AppNavigation
    
    private let profile: Profile
    private let shopTypes: ShopTypes
    private let promos: Promos
    private let shops: Shops
    
    public init(
        navigation: AppNavigation,
        profile: Profile,
        shopTypes: ShopTypes,
        promos: Promos,
        shops: Shops
    ) {
        self.navigation = navigation
        self.profile = profile
        self.shopTypes = shopTypes
        self.promos = promos
        self.shops = shops
    }
}

// MARK: - Main Page Components

extension UIComposer {
    
    @ViewBuilder
    public func makeAddressView(
        route: AddressPickerModel.Route? = nil
    ) -> some View {
        let street = profile.address?.street.rawValue
        
        AddressView(street: street) { [weak self] in
            self?.navigation.route = .addressPicker(route)
        }
        .padding(.horizontal)
    }
    
    public func makeDeliveryTypePicker() -> some View {
        DeliveryTypePicker(deliveryType: .constant(.all))
            .padding(.horizontal)
    }
    
    public func makeShopTypeStrip(route: ShopTypeStripViewModel.Route? = nil) -> some View {
        ShopTypeStrip(
            viewModel: .init(
                shopTypes: shopTypes,
                route: route
            ),
            shopTypeView: shopTypeImageView,
            shopTypeDestination: shopTypeDestination
        )
    }
    
    private func shopTypeImageView(shopType: ShopType) -> some View {
        VStack {
            Color.pink
                .frame(width: 80, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
            
            Text(shopType.title)
                .font(.caption)
        }
    }
    
    private func shopTypeDestination(shopType: ShopType) -> some View {
        ScrollView(showsIndicators: false) {
            ShopGridView(
                viewModel: .init(
                    shops: self.shops.filter({ $0.shopType == shopType })
                ),
                shopView: makeShopView
            )
            .padding(.horizontal)
        }
        .navigationTitle(shopType.title)
    }
    
    public func makeFeaturedShopsView() -> some View {
        FeaturedShopsView()
    }
    
    public func makeNewFeatureView() -> some View {
        NewFeatureView()
    }
    
    public func makePromoStrip() -> some View {
        PromoStrip(promos: promos, promoView: promoView)
    }
    
    private func promoView(promo: Promo) -> some View {
        Text(promo.id.rawValue.uuidString)
            .font(.caption)
            .padding()
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
    }
    
    public func makeShopGridView(route: ShopGridViewModel.Route? = nil) -> some View {
        ShopGridView(
            viewModel: .init(
                shops: .preview,
                route: route
            ),
            shopView: makeShopView
        )
        .padding(.horizontal)
    }
    
    public func makeShowProfileButton() -> some View {
        ShowProfileButton(profile: profile) { [weak self] in
            guard let self else { return }
            
            self.navigation.showProfileButtonTapped(profile: self.profile)
        }
    }
}

// MARK: - Destination Components

extension UIComposer {
    
#warning("fix this - need profile binding")
    public func makeAddressPicker(
        route: AddressPickerModel.Route?
    ) -> some View {
        NavigationStack {
            AddressPicker(
                viewModel: .init(
                    route: route,
                    profile: self.profile
                ) { _ in
#warning("fix this")
                } addAddressAction: { [weak self] in
                    guard let self else { return }
                    
                    self.navigation.addNewAddressButtonTapped(profile: self.profile)
                }
            ) {
                self.newAddressView()
            }
        }
    }
    
    private func newAddressView() -> some View {
        Text("TBD: Add new address injected view")
    }
    
    public func makeShopTypeView(for shopType: ShopType) -> some View {
        ShopTypeView()
    }
    
    public func makeShopView(for shop: Shop) -> some View {
        ShopView(shop: shop)
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
        case let .addressPicker(route):
            makeAddressPicker(route: route)
            
        case let .shopType(shopType):
            makeShopTypeView(for: shopType)
            
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

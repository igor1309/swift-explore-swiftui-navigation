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
    private let categories: Categories
    private let promos: Promos
    private let shops: Shops
    
    public init(
        navigation: AppNavigation,
        profile: Profile,
        categories: Categories,
        promos: Promos,
        shops: Shops
    ) {
        self.navigation = navigation
        self.profile = profile
        self.categories = categories
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
    
    public func makeCategoryStrip(route: CategoryStripViewModel.Route? = nil) -> some View {
        CategoryStrip(
            viewModel: .init(
                categories: categories,
                route: route
            ),
            categoryView: categoryImageView,
            categoryDestination: categoryDestination
        )
    }
    
    private func categoryImageView(category: Category) -> some View {
        VStack {
            Color.pink
                .frame(width: 80, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
            
            Text(category.title)
                .font(.caption)
        }
    }
    
    private func categoryDestination(category: Category) -> some View {
        ScrollView(showsIndicators: false) {
            ShopGridView(
                viewModel: .init(
                    shops: self.shops.filter({ $0.category == category })
                )
            )
            .padding(.horizontal)
        }
        .navigationTitle(category.title)
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
            )
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
        case let .addressPicker(route):
            makeAddressPicker(route: route)
            
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

//
//  UIComposer.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI

public final class UIComposer {
    
    let navigation: AppNavigation
    
    private let shops: Shops
    
    public init(
        navigation: AppNavigation,
        shops: Shops
    ) {
        self.navigation = navigation
        self.shops = shops
    }
}

// MARK: - Main Page Components

extension UIComposer {
    
    @ViewBuilder
    public func makeAddressView(
        street: Address.Street?,
        route: AddressPickerModel.Route?
    ) -> some View {
        AddressView(street: street?.rawValue) { [weak self] in
            self?.navigation.navigate(to: .addressPicker(route))
        }
        .padding(.horizontal)
    }
    
    public func makeDeliveryTypePicker() -> some View {
        DeliveryTypePicker(deliveryType: .constant(.all))
            .padding(.horizontal)
    }
    
    public func makeShopTypeStrip(
        shopTypes: ShopTypes,
        route: ShopTypeStripViewModel.Route?
    ) -> some View {
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
    
    private func makeShopView(for shop: Shop) -> some View {
        makeShopView(viewModel: .init(shop: shop))
    }
    
    public func makeFeaturedShopsView() -> some View {
        FeaturedShopsView()
    }
    
    public func makeNewFeatureView() -> some View {
        NewFeatureView()
    }
    
    public func makePromoStrip(promos: Promos) -> some View {
        PromoStrip(promos: promos, promoView: promoView)
    }
    
    private func promoView(promo: Promo) -> some View {
        Text(promo.id.rawValue.uuidString)
            .font(.caption)
            .padding()
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
    }
    
    public func makeShopGridView(
        route: ShopGridViewModel.Route?
    ) -> some View {
        ShopGridView(
            viewModel: .init(
                shops: .preview,
                route: route
            ),
            shopView: makeShopView
        )
        .padding(.horizontal)
    }
    
    public func makeShowProfileButton(profile: Profile) -> some View {
        ShowProfileButton(profile: profile) { [weak self] in
            guard let self else { return }
            
            self.navigation.showProfileButtonTapped(profile: profile)
        }
    }
}

// MARK: - Destination Components

extension UIComposer {
    
#warning("fix this - need profile binding")
    public func makeAddressPicker(
        profile: Profile,
        route: AddressPickerModel.Route?
    ) -> some View {
        NavigationStack {
            AddressPicker(
                viewModel: .init(
                    route: route,
                    profile: profile
                ) { _ in
#warning("fix this")
                } addAddressAction: { [weak self] in
                    guard let self else { return }
                    
                    self.navigation.addNewAddressButtonTapped(profile: profile)
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
    
    public func makeShopView(viewModel: ShopViewModel) -> some View {
        ShopView(
            viewModel: viewModel,
            categoryView: makeCategoryView,
            productView: makeProductView
        )
    }
    
    private func makeCategoryView(category: Category) -> some View {
        Text("TBD: \"\(category.title)\" category view")
    }
    
    private func makeProductView(product: Product) -> some View {
        Text("TBD: \"\(product.title)\" product view")
    }
    
    public func makeFeatureView(for feature: Feature) -> some View {
        FeatureView()
    }
    
    public func makePromoView(for promo: Promo) -> some View {
        PromoView()
    }
    
    public func makeProfileView(viewModel: ProfileViewModel) -> some View {
        ProfileView(viewModel: viewModel)
    }
    
    @ViewBuilder
    public func makeSheetDestination(
        profile: Profile,
        route: Binding<AppNavigation.Sheet>
    ) -> some View {
        
        switch route.wrappedValue {
        case let .addressPicker(route):
            makeAddressPicker(profile: profile, route: route)
            
        case let .profile(viewModel):
            NavigationStack {
                makeProfileView(viewModel: viewModel)
            }
        }
    }
    
    @ViewBuilder
    public func makeNavigationDestination(
        route: Binding<AppNavigation.Route>
    ) -> some View {
        
        switch route.wrappedValue {
        case let .shopType(shopType):
            makeShopTypeView(for: shopType)
            
        case let .featuredShop(shop):
            makeShopView(for: shop)
            
        case let .newFeature(feature):
            makeFeatureView(for: feature)
            
        case let .promo(promo):
            makePromoView(for: promo)
            
        case let .shop(viewModel):
            makeShopView(viewModel: viewModel)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

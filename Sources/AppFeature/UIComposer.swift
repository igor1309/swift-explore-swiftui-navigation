//
//  UIComposer.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import AddressPickerFeature
import AddressViewFeature
import DeliveryTypePickerFeature
import Domain
import FeaturedShopsFeature
import FeatureViewFeature
import NewAppFeatureFeature
import ProfileEditorFeature
import ProfileFeature
import PromoFeature
import PromoStripFeature
import ShopFeature
import ShopGridFeature
import ShopTypeFeature
import ShopTypeStripFeature
import ShowProfileButtonFeature
import SwiftUI

public final class UIComposer {
    
    let navigation: AppNavigation
    let appViewModel: AppViewModel
    
    public init(navigation: AppNavigation, appViewModel: AppViewModel) {
        self.navigation = navigation
        self.appViewModel = appViewModel
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
        shops: Shops,
        route: ShopTypeStripViewModel.Route?
    ) -> some View {
        ShopTypeStrip(
            viewModel: .init(
                shopTypes: shopTypes,
                route: route
            ),
            shopTypeView: shopTypeImageView,
            shopTypeDestination: {
                self.shopTypeDestination(shopType: $0, shops: shops)
            }
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
    
    private func shopTypeDestination(
        shopType: ShopType,
        shops: Shops
    ) -> some View {
        ScrollView(showsIndicators: false) {
            ShopGridView(
                viewModel: .init(
                    shops: shops.filter({ $0.shopType == shopType })
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
    
    public func makeNewAppFeatureView() -> some View {
        NewAppFeatureView()
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
    
    public func makeAddressPicker(
        profile: Profile,
        route: AddressPickerModel.Route?
    ) -> some View {
        NavigationStack {
            AddressPicker(
                viewModel: .init(
                    address: profile.address,
                    addresses: profile.addresses,
                    route: route,
                    selectAddress: appViewModel.setAddress(to:)
                ) { [weak self] in
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
    
    private func makeCategoryView(category: Domain.Category) -> some View {
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
    
#warning("ProfileView does not update on changes in ProfileEditor!")
    public func makeProfileView(viewModel: ProfileViewModel) -> some View {
        ProfileView(
            viewModel: viewModel,
            profileEditor: makeProfileEditor,
            orderHistoryView: orderHistoryView,
            faqView: faqView,
            cardsView: cardsView,
            chatView: chatView,
            callUsView: callUsView
        )
    }
    
    func makeProfileEditor(profile: Profile) -> some View {
        ProfileEditor(
            user: .init(
                name: profile.name,
                email: profile.email,
                phone: profile.phone
            ),
            saveProfile: { [weak self] user in
                self?.appViewModel.updateProfile(
                    name: user.name,
                    email: user.email,
                    phone: user.phone
                )
#warning("need to dismiss")
            },
            deleteAccount: {
#warning("finish this")
            }
        )
    }
    
    func orderHistoryView() -> some View {
        Text("TBD: Order History")
    }
    
    func faqView() -> some View {
        Text("TBD: FAQ")
    }
    
    func cardsView() -> some View {
        Text("TBD: Your Cards")
    }
    
    func chatView() -> some View {
        Text("TBD: Chat")
    }
    
    func callUsView() -> some View {
        Text("TBD: Call Us")
    }
    
    @ViewBuilder
    public func makeSheetDestination(
        profile: Profile,
        route: Binding<AppNavigation.Route.Sheet>
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
        route: Binding<AppNavigation.Route.Navigation>
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

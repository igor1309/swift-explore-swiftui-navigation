//
//  AppView.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI
import SwiftUINavigation

public struct AppView: View {
    
    private let uiComposer: UIComposer
    
    @ObservedObject var navigation: AppNavigation
    @ObservedObject var viewModel: AppViewModel
    
    public init(
        uiComposer: UIComposer
    ) {
        self.uiComposer = uiComposer
        self.navigation = uiComposer.navigation
        self.viewModel = uiComposer.appViewModel
    }
    
    public var body: some View {
        NavigationStack {
            MainPage(
                addressView: {
                    uiComposer.makeAddressView(
                        street: viewModel.profile.address?.street,
                        route: nil
                    )
                },
                deliveryTypePicker: uiComposer.makeDeliveryTypePicker,
                shopTypeStrip: {
                    uiComposer.makeShopTypeStrip(
                        shopTypes: viewModel.shopTypes,
                        shops: viewModel.shops,
                        route: nil
                    )
                },
                featuredShopsView: uiComposer.makeFeaturedShopsView,
                newFeatureView: uiComposer.makeNewFeatureView,
                promoStrip: {
                    uiComposer.makePromoStrip(
                        promos: viewModel.promos
                    )
                },
                shopGridView: {
                    uiComposer.makeShopGridView(route: nil)
                },
                showProfileButton: {
                    uiComposer.makeShowProfileButton(
                        profile: viewModel.profile
                    )
                }
            )
            .sheet(
                unwrapping: .init(
                    get: { navigation.route },
                    set: { navigation.navigate(to: $0) }
                ),
                case: /AppNavigation.Route.sheet,
                content: {
                    uiComposer.makeSheetDestination(
                        profile: viewModel.profile,
                        route: $0
                    )
                }
            )
            .navigationDestination(
                unwrapping: .init(
                    get: { navigation.route },
                    set: { navigation.navigate(to: $0) }
                ),
                case: /AppNavigation.Route.navigation,
                destination: uiComposer.makeNavigationDestination(route:)
            )
        }
    }
}

struct AppView_Previews: PreviewProvider {
    
    static let routes: [AppNavigation.Route?] = .routes
    
    static func appView(
        route: AppNavigation.Route? = nil
    ) -> some View {
        let routeCase = route?.routeCase.rawValue ?? ""
        
        return AppView(
            uiComposer: .init(
                navigation: .init(route: route),
                appViewModel: .init(
                    profile: .preview,
                    shopTypes: .preview,
                    promos: .preview,
                    shops: .preview
                )
            )
        )
        .previewDisplayName(routeCase)
    }
    
    static var previews: some View {
        ForEach(routes, id: \.self, content: appView)
            .preferredColorScheme(.dark)
    }
}

#if DEBUG
private extension Array where Element == AppNavigation.Route? {
    
    static let routes: Self = [
        .none,
        .sheet(.addressPicker()),
        .sheet(.addressPicker(.newAddress)),
        .sheet(.profile(.preview)),
        .navigation(.shopType(.preview)),
        .navigation(.featuredShop(.preview)),
        .navigation(.newFeature(.preview)),
        .navigation(.promo(.preview)),
        .navigation(.shop(.preview)),
    ]
}
private extension AppNavigation.Route {
    
    var routeCase: RouteCase {
        switch self {
        case let .sheet(sheet):
            switch sheet {
            case .profile:
                return .profile
            case .addressPicker:
                return .addressPicker
            }
            
        case let .navigation(navigation):
            switch navigation {
            case .shopType:
                return .shopType
            case .featuredShop:
                return .featuredShop
            case .newFeature:
                return .newFeature
            case .promo:
                return .promo
            case .shop:
                return .shop
            }
        }
    }
    
    enum RouteCase: String {
        case addressPicker
        case profile
        case newAddress
        case shopType
        case featuredShop
        case newFeature
        case promo
        case shop
    }
}
#endif

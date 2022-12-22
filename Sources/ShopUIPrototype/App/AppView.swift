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
                    get: { navigation.sheet },
                    set: { navigation.navigate(to: $0) }
                ),
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
                destination: uiComposer.makeNavigationDestination(route:)
            )
        }
    }
}

struct AppView_Previews: PreviewProvider {
    
    static let routes: [AppNavigation.Route?] = .routes
    static let sheets: [AppNavigation.Sheet?] = .routes
    
    static func appView(
        route: AppNavigation.Route? = nil,
        sheet: AppNavigation.Sheet? = nil
    ) -> some View {
        let routeCase = route?.routeCase.rawValue ?? ""
        let sheetCase = sheet?.routeCase.rawValue ?? ""
        
        return AppView(
            uiComposer: .init(
                navigation: .init(
                    route: route,
                    sheet: sheet
                ),
                appViewModel: .init(
                    profile: .preview,
                    shopTypes: .preview,
                    promos: .preview,
                    shops: .preview
                )
            )
        )
        .previewDisplayName(routeCase + " " + sheetCase)
    }
    
    static var previews: some View {
        ForEach(sheets, id: \.self) { sheet in
            ForEach(routes, id: \.self) { route in
                appView(route: route, sheet: sheet)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#if DEBUG
private extension Array where Element == AppNavigation.Route? {
    
    static let routes: Self = [
        .none,
        .shopType(.preview),
        .featuredShop(.preview),
        .newFeature(.preview),
        .promo(.preview),
        .shop(.preview),
    ]
}

private extension Array where Element == AppNavigation.Sheet? {
    
    static let routes: Self = [
        .none,
        .addressPicker(),
        .addressPicker(.newAddress),
        .profile(.preview),
    ]
}
private extension AppNavigation.Route {
    
    var routeCase: RouteCase {
        switch self {
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
    
    enum RouteCase: String {
        case newAddress
        case shopType
        case featuredShop
        case newFeature
        case promo
        case shop
    }
}

private extension AppNavigation.Sheet {
    
    var routeCase: RouteCase {
        switch self {
        case .addressPicker:
            return .addressPicker
        case .profile:
            return .profile
        }
    }
    
    enum RouteCase: String {
        case addressPicker
        case profile
    }
}
#endif

//
//  AppView.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI

struct AppView: View {
    
    let uiComposer: UIComposer
    let profile: Profile
    
    @ObservedObject var navigation: AppNavigation
    
    var body: some View {
        NavigationStack {
            MainPage(
                addressView: uiComposer.makeAddressView,
                deliveryTypePicker: uiComposer.makeDeliveryTypePicker,
                categoryStrip: uiComposer.makeCategoryStrip,
                featuredShopsView: uiComposer.makeFeaturedShopsView,
                newFeatureView: uiComposer.makeNewFeatureView,
                promoStrip: uiComposer.makePromoStrip,
                shopGridView: uiComposer.makeShopGridView,
                showProfileButton: {
                    uiComposer.makeShowProfileButton(profile: profile)
                }
            )
            .sheet(
                item: $navigation.route,
                content: uiComposer.destination(route:)
            )
        }
    }
}

struct AppView_Previews: PreviewProvider {
    
    static let routes: [AppNavigation.Route?] = .routes
    
    static func appView(route: AppNavigation.Route? = nil) -> some View {
        AppView(
            uiComposer: .preview,
            profile: .preview,
            navigation: .init(route: route)
        )
        .previewDisplayName(route?.routeCase.rawValue ?? "")
    }
    
    static var previews: some View {
        ForEach(routes, id: \.self, content: appView)
            .preferredColorScheme(.dark)
    }
}

#if DEBUG
private extension Address {
    static let preview: Self = .init(id: .init())
}
private extension Category {
    static let preview: Self = .init(id: .init())
}
private extension Shop {
    static let preview: Self = .init(id: .init())
}
private extension Feature {
    static let preview: Self = .init(id: .init())
}
private extension Promo {
    static let preview: Self = .init(id: .init())
}
private extension Profile {
    static let preview: Self = .init(id: .init())
}
private extension Array where Element == AppNavigation.Route? {
    
    static let routes: Self = [
        .none,
        .address(.preview),
        .category(.preview),
        .featuredShop(.preview),
        .newFeature(.preview),
        .promo(.preview),
        .shop(.preview),
        .profile(.preview),
    ]
}

private extension AppNavigation {
    static let preview = AppNavigation()
}

private extension UIComposer {
    static let preview = UIComposer(navigation: .preview)
}

private extension AppNavigation.Route {
    
    var routeCase: RouteCase {
        switch self {
        case .address:
            return .address
        case .category:
            return .category
        case .featuredShop:
            return .featuredShop
        case .newFeature:
            return .newFeature
        case .promo:
            return .promo
        case .shop:
            return .shop
        case .profile:
            return .profile
        }
    }
    
    enum RouteCase: String {
        case address
        case category
        case featuredShop
        case newFeature
        case promo
        case shop
        case profile
    }
}
#endif

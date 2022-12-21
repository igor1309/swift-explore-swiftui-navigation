//
//  AppView.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI

public struct AppView: View {
    
    let uiComposer: UIComposer
    
    @ObservedObject var navigation: AppNavigation
    
    public init(
        uiComposer: UIComposer
    ) {
        self.uiComposer = uiComposer
        self.navigation = uiComposer.navigation
    }
    
    public var body: some View {
        NavigationStack {
            MainPage(
                addressView: {
                    uiComposer.makeAddressView()
                },
                deliveryTypePicker: uiComposer.makeDeliveryTypePicker,
                categoryStrip: {
                    uiComposer.makeCategoryStrip()
                },
                featuredShopsView: uiComposer.makeFeaturedShopsView,
                newFeatureView: uiComposer.makeNewFeatureView,
                promoStrip: uiComposer.makePromoStrip,
                shopGridView: {
                    uiComposer.makeShopGridView()
                },
                showProfileButton: {
                    uiComposer.makeShowProfileButton()
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
            uiComposer: .preview(
                navigation: .init(route: route)
            )
        )
        .previewDisplayName(route?.routeCase.rawValue ?? "")
    }
    
    static var previews: some View {
        ForEach(routes, id: \.self, content: appView)
            .preferredColorScheme(.dark)
    }
}

#if DEBUG
public extension Address {
    
    static let preview: Self = .init(
        id: .init(),
        street: .init("Some Street, 123")
    )
    static let second: Self = .init(
        id: .init(),
        street: .init("Second Avenue, 45")
    )
}

public extension Category {
    static let preview: Self = .init(id: .init(), title: "Flowers")
}

public extension Shop {
    
    static let preview: Self = .init(
        title: "Mr. Bouquet",
        category: .preview
    )
}
public extension Feature {
    static let preview: Self = .init(id: .init())
}
public extension Promo {
    static let preview: Self = .init(id: .init())
}
public extension Profile {
    
    static let preview: Self = .init(
        address: .preview,
        addresses: [.preview, .second]
    )
}
private extension Array where Element == AppNavigation.Route? {
    
    static let routes: Self = [
        .none,
        .addressPicker(),
        .addressPicker(.newAddress),
        .category(.preview),
        .featuredShop(.preview),
        .newFeature(.preview),
        .promo(.preview),
        .shop(.preview),
        .profile(.preview),
    ]
}

public extension AppNavigation {
    static let preview = AppNavigation()
}

public extension UIComposer {
    
    static func preview(navigation: AppNavigation) -> UIComposer {
        .init(
            navigation: navigation,
            profile: .preview,
            categories: .preview,
            promos: .preview,
            shops: .preview
        )
    }
}

private extension AppNavigation.Route {
    
    var routeCase: RouteCase {
        switch self {
        case .addressPicker:
            return .addressPicker
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
        case addressPicker
        case newAddress
        case category
        case featuredShop
        case newFeature
        case promo
        case shop
        case profile
    }
}
#endif

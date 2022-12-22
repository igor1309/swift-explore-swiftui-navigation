//
//  ContentView.swift
//  ShopUIPrototypePreviewApp
//
//  Created by Igor Malyarov on 21.12.2022.
//

import ShopUIPrototype
import SwiftUI

struct ContentView: View {
    
    // private let route: AppNavigation.Route? = nil
    private let route: AppNavigation.Route? = Route.cards()
    
    var body: some View {
        AppView(
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - Helpers

/// namespace
private enum Route {
    
    static func addressPicker() -> AppNavigation.Route {
        .sheet(.addressPicker())
    }
    static func newAddress() -> AppNavigation.Route {
        .sheet(.addressPicker(.newAddress))
    }
    static func editProfile() -> AppNavigation.Route {
        .sheet(.profile(.init(profile: .preview, route: .editProfile)))
    }
    static func orderHistory() -> AppNavigation.Route {
        .sheet(.profile(.init(profile: .preview, route: .orderHistory)))
    }
    static func faq() -> AppNavigation.Route {
        .sheet(.profile(.init(profile: .preview, route: .faq)))
    }
    static func cards() -> AppNavigation.Route {
        .sheet(.profile(.init(profile: .preview, route: .cards)))
    }
    static func shop() -> AppNavigation.Route {
        .navigation(.shop(.preview))
    }
    static func categoryInShop() -> AppNavigation.Route {
        .navigation(.shop(.init(shop: .preview, route:
                .category(.preview))))
    }
    static func product() -> AppNavigation.Route {
        .navigation(.shop(.init(shop: .preview, route: .product(.preview))))
    }
}

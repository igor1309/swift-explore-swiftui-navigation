//
//  ContentView.swift
//  ShopUIPrototypePreviewApp
//
//  Created by Igor Malyarov on 21.12.2022.
//

import AppFeature
import SwiftUI

struct ContentView: View {
    
    // private let route: AppNavigation.Route? = nil
    private let route: AppNavigation.Route? = Route.logout()
    
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
    static func profile() -> AppNavigation.Route {
        .sheet(.profile(.init(profile: .preview, route: nil, logout: { fatalError("unimplemented")} )))
    }
    static func logout() -> AppNavigation.Route {
        .sheet(.profile(.init(profile: .preview, route: .alert(.logout), logout: { fatalError("unimplemented")} )))
    }
    static func editProfile() -> AppNavigation.Route {
        .sheet(.profile(.init(profile: .preview, route: .navigation(.editProfile), logout: { fatalError("unimplemented")} )))
    }
    static func orderHistory() -> AppNavigation.Route {
        .sheet(.profile(.init(profile: .preview, route: .navigation(.orderHistory), logout: { fatalError("unimplemented")} )))
    }
    static func faq() -> AppNavigation.Route {
        .sheet(.profile(.init(profile: .preview, route: .navigation(.faq), logout: { fatalError("unimplemented")} )))
    }
    static func cards() -> AppNavigation.Route {
        .sheet(.profile(.init(profile: .preview, route: .navigation(.cards), logout: { fatalError("unimplemented")} )))
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

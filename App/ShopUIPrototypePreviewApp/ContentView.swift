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
    private let route: AppNavigation.Route? = .logout
    
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
private extension AppNavigation.Route {
    
    static let addressPicker: Self = .sheet(.addressPicker())
    static let newAddress: Self = .sheet(.addressPicker(.newAddress))
    static let profile: Self = .sheet(.profile(.init(profile: .preview, route: nil, logout: { fatalError("unimplemented")} )))
    static let logout: Self = .sheet(.profile(.init(profile: .preview, route: .alert(.logout), logout: { fatalError("unimplemented")} )))
    static let editProfile: Self = .sheet(.profile(.init(profile: .preview, route: .navigation(.editProfile), logout: { fatalError("unimplemented")} )))
    static let orderHistory: Self = .sheet(.profile(.init(profile: .preview, route: .navigation(.orderHistory), logout: { fatalError("unimplemented")} )))
    static let faq: Self = .sheet(.profile(.init(profile: .preview, route: .navigation(.faq), logout: { fatalError("unimplemented")} )))
    static let cards: Self = .sheet(.profile(.init(profile: .preview, route: .navigation(.cards), logout: { fatalError("unimplemented")} )))
    static let shop: Self = .navigation(.shop(.preview))
    static let categoryInShop: Self = .navigation(.shop(.init(shop: .preview, route:
            .category(.preview))))
    static let product: Self = .navigation(.shop(.init(shop: .preview, route: .product(.preview))))
}

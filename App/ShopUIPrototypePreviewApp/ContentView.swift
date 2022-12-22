//
//  ContentView.swift
//  ShopUIPrototypePreviewApp
//
//  Created by Igor Malyarov on 21.12.2022.
//

import ShopUIPrototype
import SwiftUI

struct ContentView: View {
    
//    private let sheet = AppNavigation.Sheet.addressPicker()
//    private let sheet = AppNavigation.Sheet.addressPicker(.newAddress)
    private let sheet = AppNavigation.Sheet.profile(.init(profile: .preview, route: .editProfile))
//    private let sheetRoute = AppNavigation.Sheet.profile(.init(profile: .preview, route: .a))
//    private let route = AppNavigation.Route.shop(.preview)
    private let route = AppNavigation.Route.shop(.init(shop: .preview, route: .category(.preview)))
//    private let route = AppNavigation.Route.shop(.init(shop: .preview, route: .product(.preview)))

    
    var body: some View {
        AppView(
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

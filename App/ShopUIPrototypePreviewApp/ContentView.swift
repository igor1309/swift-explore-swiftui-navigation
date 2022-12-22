//
//  ContentView.swift
//  ShopUIPrototypePreviewApp
//
//  Created by Igor Malyarov on 21.12.2022.
//

import ShopUIPrototype
import SwiftUI

struct ContentView: View {
    var body: some View {
        AppView(
            viewModel: .init(
                profile: .preview,
                shopTypes: .preview,
                promos: .preview,
                shops: .preview
            ),
            uiComposer: .preview(
                navigation: .init(
                    // sheetRoute: .addressPicker()
                    // sheetRoute: .addressPicker(.newAddress)
                    sheetRoute: .profile(.init(profile: .preview, route: .editProfile))
                    // sheetRoute: .profile(.init(profile: .preview, route: .a))
                    // route: .shop(.preview)
                    // route: .shop(.init(shop: .preview, route: .category(.preview)))
                    // route: .shop(.init(shop: .preview, route: .product(.preview)))
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

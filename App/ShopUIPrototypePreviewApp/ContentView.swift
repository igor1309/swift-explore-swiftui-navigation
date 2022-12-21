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
            uiComposer: .preview(
                navigation: .init(
//                     sheetRoute: .addressPicker()
                     sheetRoute: .addressPicker(.newAddress)
//                     route: .shop(.preview)
//                    route: .shop(.init(shop: .preview, route: .category(.preview)))
//                    route: .shop(.init(shop: .preview, route: .product(.preview)))
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

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
                    // route: .addressPicker()
                    route: .addressPicker(.newAddress)
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

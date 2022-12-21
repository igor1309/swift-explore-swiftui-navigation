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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

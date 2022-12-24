//
//  ContentView.swift
//  MapViewPreviewApp
//
//  Created by Igor Malyarov on 24.12.2022.
//

import MapFeature
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            MapViewDemo(viewModel: .live(region: .moscowStreet))
                .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

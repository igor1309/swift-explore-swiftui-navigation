//
//  ContentView.swift
//  AddressMapSearchPreviewApp
//
//  Created by Igor Malyarov on 28.12.2022.
//

import AddressMapSearchFeature
import MapDomain
import MapKit
import MapKitMapFeature
import SwiftUI

struct ContentView: View {
    
    @State private var viewModel: AddressMapSearchViewModel = .preview//.failing
    
    var body: some View {
        AddressMapSearchView(
            viewModel: viewModel,
            mapView: mapView
        )
        .safeAreaInset(edge: .bottom, content: watch)
        .toolbar(content: toolbar)
    }
    
    private func mapView(region: Binding<CoordinateRegion>) -> some View {
        Map(region: region)
    }
    
    private func watch() -> some View {
        VStack {
            Text(location)
                .padding(2)
            
            Text(viewModel.region.center.latitude.formatted(.number))
            Text(viewModel.region.center.longitude.formatted(.number))
        }
        .font(.caption)
        .padding(.bottom)
        .monospaced()
    }
    
    var location: String {
        let street = viewModel.address?.street ?? "street n/a"
        let city = viewModel.address?.city ?? "city n/a"
        
        return street + " | " + city
    }
    
    private func toolbar() -> some ToolbarContent {
        ToolbarItem {
            Menu("Places") {
                ForEach([Place].preview) { place in
                    Button(place.title) {
                        viewModel.update(region: place.region)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Place: Identifiable {
    
    let id: UUID
    let title: String
    let region: CoordinateRegion
    
    init(id: ID = .init(), title: String, region: CoordinateRegion) {
        self.id = id
        self.title = title
        self.region = region
    }
}

extension Place {
    
    static let barcelona: Self = .init(title: "Barcelona", region: .streetBarcelona)
    static let london:    Self = .init(title: "London",    region: .streetLondon)
    static let moscow:    Self = .init(title: "Moscow",    region: .streetMoscow)
    static let paris:     Self = .init(title: "Paris",     region: .street(center: .paris))
    static let rome:      Self = .init(title: "Rome",      region: .street(center: .rome))
}

extension Array where Element == Place {
    
    static let preview: Self = [.barcelona, .london, .moscow, .paris, .rome]
}

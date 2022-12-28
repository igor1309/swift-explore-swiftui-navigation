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
    
    @StateObject private var viewModel: AddressMapSearchViewModel = .delayedPreview//.preview//.failing
    
    var body: some View {
        AddressMapSearchView(
            viewModel: viewModel,
            mapView: mapView
        )
        .ignoresSafeArea()
    }
    
    private func mapView(region: Binding<CoordinateRegion>) -> some View {
        Map(region: region)
        // Color.indigo
            .safeAreaInset(edge: .bottom) {
                VStack {
                    HStack {
                        ForEach([Place].preview) { place in
                            Button(place.title) {
                                viewModel.updateAndSearch(region: place.region)
                            }
                        }
                    }
                    Text(location)
                        .padding(2)
                    
                    HStack {
                        Text(region.wrappedValue.center.description)
                        Text(region.wrappedValue.span.description)
                    }
                }
                .font(.caption)
                .padding(.bottom)
                .monospaced()
            }
    }
    
    var location: String {
        let street = viewModel.address?.street ?? "street n/a"
        let city = viewModel.address?.city ?? "city n/a"
        
        return street + " | " + city
    }
}

extension LocationCoordinate2D: CustomStringConvertible {
    
    public var description: String {
        """
        Coordinate
        \t\(latitude.formatted(.number.precision(.fractionLength(4))))
        \t\(longitude.formatted(.number.precision(.fractionLength(4))))
        """
    }
}

extension CoordinateSpan: CustomStringConvertible {
    
    public var description: String {
        """
        Span
        \(latitudeDelta.formatted(.number.precision(.fractionLength(4))))
        \(longitudeDelta.formatted(.number.precision(.fractionLength(4))))
        """
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

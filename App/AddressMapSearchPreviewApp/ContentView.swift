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
    
    @State private var useCase: UseCase = .delayed
    
    var body: some View {
        AddressMapSearchView(
            viewModel: useCase.viewModel,
            mapView: mapView
        )
        .ignoresSafeArea()
    }
    
    private func mapView(region: Binding<CoordinateRegion>) -> some View {
        Map(region: region)
        // Color.indigo
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Picker("Use case", selection: $useCase) {
                        ForEach(UseCase.allCases) { useCase in
                            Text(useCase.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 6)
                    
                    HStack {
                        ForEach([Place].preview) { place in
                            Button(place.title) {
                                useCase.viewModel.updateAndSearch(region: place.region)
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
        let street = useCase.viewModel.address?.street ?? "street n/a"
        let city = useCase.viewModel.address?.city ?? "city n/a"
        
        return street + " | " + city
    }
    
    enum UseCase: String, CaseIterable, Identifiable {
        case failing, delayed, preview
        
        var id: Self { self }
        
        var viewModel: AddressMapSearchViewModel {
            switch self {
            case .failing:
                return .failing
            case .delayed:
                return .delayedPreview
            case .preview:
                return .preview
            }
        }
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
    
    static let barcelona: Self = .init(title: "Barcelona", region: .neighborhood(center: .barcelona))
    static let london:    Self = .init(title: "London",    region: .neighborhood(center: .london))
    static let moscow:    Self = .init(title: "Moscow",    region: .neighborhood(center: .moscow))
    static let paris:     Self = .init(title: "Paris",     region: .neighborhood(center: .paris))
    static let rome:      Self = .init(title: "Rome",      region: .neighborhood(center: .rome))
}

extension Array where Element == Place {
    
    static let preview: Self = [.barcelona, .london, .moscow, .paris, .rome]
}

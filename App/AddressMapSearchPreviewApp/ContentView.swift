//
//  ContentView.swift
//  AddressMapSearchPreviewApp
//
//  Created by Igor Malyarov on 28.12.2022.
//

import AddressMapSearchFeature
import AddressSearchService
import Combine
import GeocoderAddressCoordinateSearchService
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
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    private func mapView(region: Binding<CoordinateRegion>) -> some View {
        Map(region: region)
        // Color.indigo
            .ignoresSafeArea()
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
                .padding(.top, 6)
                .monospaced()
                .background(.thinMaterial)
            }
    }
    
    var location: String {
        let street = useCase.viewModel.address?.street ?? "street n/a"
        let city = useCase.viewModel.address?.city ?? "city n/a"
        
        return street + " | " + city
    }
    
    enum UseCase: String, CaseIterable, Identifiable {
        case failing, live, delayed, preview
        
        var id: Self { self }
        
        var viewModel: AddressMapSearchViewModel {
            switch self {
            case .failing:
                return .failing
            case .live:
                return .live
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

// MARK: - Adapters

typealias MapAddress = AddressMapSearchFeature.Address
typealias SearchAddress = AddressSearchService.Address

typealias GeocoderAddress = GeocoderAddressCoordinateSearchService.Address
typealias FeatureAddress = AddressMapSearchFeature.Address

typealias GeocoderAddressResultPublisher = AnyPublisher<Result<[GeocoderAddress], Error>, Never>
typealias SearchGeocoderAddresses = (Completion, CoordinateRegion) -> GeocoderAddressResultPublisher

extension Swift.Optional where Wrapped == GeocoderAddress {
    
    var featureAddress: FeatureAddress? {
        guard let wrapped = self else {
            return nil
        }
        
        return wrapped.featureAddress
    }
}

extension AddressMapSearchViewModel {
    
    static let live: AddressMapSearchViewModel = .init(
        initialRegion: .townLondon,
        getAddressFromCoordinate: getAddressFromCoordinate,
        getCompletions: getCompletions,
        search: search
    )
    
    private static func getAddressFromCoordinate(
        coordinate: LocationCoordinate2D
    ) -> AddressPublisher {
        let addressCoordinateSearch = GeocoderAddressCoordinateSearch()
        
        return addressCoordinateSearch
            .getAddress(from: coordinate)
            .map(\.featureAddress)
            .eraseToAnyPublisher()
    }
    
    private static func getCompletions(text: String) -> CompletionsPublisher {
        print("getCompletions", text)
        let completer = LocalSearchCompleter()
        _ = completer
        return completer
            .searchCompletions(text)
            .handleEvents(receiveOutput: {
                print("LocalSearchCompleter:", String(describing: $0))
            })
            .map(\.searchCompletions)
            .handleEvents(receiveOutput: {
                print("searchCompletions:", String(describing: $0))
            })
            .map { $0.map(\.completion) }
            .handleEvents(receiveOutput: {
                print("completion:", String(describing: $0))
            })
            .eraseToAnyPublisher()
    }
    
#warning("use region")
    private static func search(completion: Completion) -> SearchPublisher {
        LocalTextSearchClient.live
            .searchAddresses(completion: completion, region: nil)
            .eraseToAnyPublisher()
    }
}

typealias MapAddressPublisher = AnyPublisher<[MapAddress], Never>

private extension LocalTextSearchClient {
    
    func searchAddresses(
        completion: Completion,
        region: CoordinateRegion?
    ) -> MapAddressPublisher {
        searchAddresses(
            completion.title + " " + completion.subtitle,
            region: region
        )
        .map(\.addresses)
        .map { $0.map(\.mapAddress) }
        .eraseToAnyPublisher()
    }
}

// MARK: - Completion Adapters

private extension LocalSearchCompletion {
    
    var completion: Completion {
        .init(
            title: title,
            subtitle: subtitle,
            titleHighlightRanges: titleHighlightRanges,
            subtitleHighlightRanges: subtitleHighlightRanges
        )
    }
}

// MARK: - Result Adapters

private extension CompletionsResult {
    
    var searchCompletions: [LocalSearchCompletion] {
        switch self {
        case .failure:
            return []
            
        case let .success(searchCompletions):
            return searchCompletions
        }
    }
}

private extension Result where Success == [GeocoderAddress] {
    
    var addresses: [GeocoderAddress] {
        switch self {
        case .failure:
            return []
            
        case let .success(addresses):
            return addresses
        }
    }
}

private extension Result where Success == [SearchAddress] {
    
    var addresses: [SearchAddress] {
        switch self {
        case .failure:
            return []
            
        case let .success(addresses):
            return addresses
        }
    }
}

// MARK: - Address Adapters

extension SearchAddress {
    
    var mapAddress: MapAddress {
        .init(street: .init(street), city: .init(city))
    }
}

extension GeocoderAddress {
    
    var searchAddress: SearchAddress {
        .init(street: street, city: city)
    }
}

extension GeocoderAddress {
    
    var featureAddress: FeatureAddress {
        .init(street: .init(street), city: .init(city))
    }
}


//
//  ContentView.swift
//  AddressMapSearchPreviewApp
//
//  Created by Igor Malyarov on 28.12.2022.
//

import AddressMapSearchFeature
import AddressSearchService
import CasePaths
import Combine
import GeocoderAddressCoordinateSearchService
import MapDomain
import MapKit
import MapKitMapFeature
import SwiftUI

struct ContentView: View {
    
    @State private var useCase: UseCase = .live
    
    var body: some View {
        AddressMapSearchView(
            viewModel: useCase.viewModel,
            mapView: mapView
        )
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationTitle("Search address")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func mapView(region: Binding<CoordinateRegion>) -> some View {
        Map(region: region)
        // Color.indigo
            .ignoresSafeArea()
        // .safeAreaInset(edge: .bottom) { watch(region: region.wrappedValue) }
    }
    
    private func watch(region: CoordinateRegion) -> some View {
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
                        useCase.viewModel.updateRegion(to: place.region)
                    }
                }
            }
            Text(location)
                .padding(2)
            
            HStack {
                Text(region.center.description)
                Text(region.span.description)
            }
        }
        .font(.caption)
        .padding(.top, 6)
        .monospaced()
        .background(.thinMaterial)
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

typealias MapAddress = AddressMapSearchFeature.Address

extension AddressMapSearchViewModel {
    
    var address: MapAddress? {
        guard let addressState = state.addressState else {
            return nil
        }
        
        let casePath = /AddressMapSearchState.AddressState.address
        return casePath.extract(from: addressState)
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
    
    static let barcelona: Self = .init("Barcelona", .neighborhood(center: .barcelona))
    static let london:    Self = .init("London",    .neighborhood(center: .london))
    static let moscow:    Self = .init("Moscow",    .neighborhood(center: .moscow))
    static let paris:     Self = .init("Paris",     .neighborhood(center: .paris))
    static let rome:      Self = .init("Rome",      .neighborhood(center: .rome))
    
    private init(_ title: String, _ region: CoordinateRegion) {
        self.init(title: title, region: region)
    }
}

extension Array where Element == Place {
    
    static let preview: Self = [.barcelona, .london, .moscow, .paris, .rome]
}

// MARK: - Adapters

extension AddressMapSearchViewModel {
    
    static let live: AddressMapSearchViewModel = .init(
        initialRegion: .townLondon,
        // coordinateSearch: getAddressFromCoordinate,
        coordinateSearch: GeocoderAddressCoordinateSearch(),
        isClose: { isClose($0, to: $1, withAccuracy: 0.0001) },
        // getCompletions: getCompletions,
        searchCompleter: LocalSearchCompleter(),
        // search: search
        localSearch: LocalTextSearchClient.live
    )
}

// MARK: - CoordinateSearch Adapters

extension GeocoderAddressCoordinateSearch: CoordinateSearch {
    
    public func search(
        for coordinate: LocationCoordinate2D
    ) -> AddressResultPublisher {
        getAddress(from: coordinate)
            .map { address in
                guard let address else {
                    return .failure(NSError(domain: "address", code: 0))
                }
                return .success(address.featureAddress)
            }
            .eraseToAnyPublisher()
    }
}

private extension GeocoderAddressCoordinateSearchService.Address {
    
    var featureAddress: AddressMapSearchFeature.Address {
        .init(street: .init(street), city: .init(city))
    }
}

// MARK: - SearchCompleter Adapters

extension LocalSearchCompleter: SearchCompleter {
    
    public func complete(query: String) -> CompletionsResultPublisher {
        searchCompletions(query)
            .map(\.searchCompletionsResult)
            .eraseToAnyPublisher()
    }
}

private extension CompletionsResult {
    
    var searchCompletionsResult: SearchCompleter.CompletionsResult {
        map { $0.map(Completion.init(completion:)) }
    }
}

private extension Completion {
    
    init(completion: LocalSearchCompletion) {
        self.init(
            title: completion.title,
            subtitle: completion.subtitle,
            titleHighlightRanges: completion.titleHighlightRanges,
            subtitleHighlightRanges: completion.subtitleHighlightRanges
        )
    }
}

// MARK: - LocalSearch Adapters

extension LocalTextSearchClient: LocalSearch {
    
    public func search(completion: Completion) -> SearchResultPublisher {
        searchAddresses(
            completion.title + " " + completion.subtitle,
            region: nil
        )
        .map(\.localSearchResult)
        .eraseToAnyPublisher()
    }
}

private extension LocalTextSearchClient.SearchResult {
    
    var localSearchResult: LocalSearch.SearchResult {
        map { items in
            items.map { (address, region) in
                SearchItem(address: address.mapAddress, region: region)
            }
        }
    }
}

private extension AddressSearchService.Address {
    
    var mapAddress: MapAddress {
        .init(street: .init(street), city: .init(city))
    }
}

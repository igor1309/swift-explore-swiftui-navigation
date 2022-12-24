//
//  AddNewAddressView.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import SwiftUI

public struct AddNewAddressView<MapView: View>: View {
    
    @ObservedObject private var viewModel: AddNewAddressViewModel
    
    private let mapView: () -> MapView
    
    public init(
        viewModel: AddNewAddressViewModel,
        mapView: @escaping () -> MapView
    ) {
        self.viewModel = viewModel
        self.mapView = mapView
    }
    
    public var body: some View {
        mapView()
            .ignoresSafeArea()
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: toolbar)
            .searchable(
                text: .init(
                    get: { viewModel.searchText },
                    set: viewModel.setSearchText
                ),
                prompt: Text("SEARCH_FIELD", bundle: .module)
            )
            .searchSuggestions(searchSuggestions)
    }
    
    private var navigationTitle: Text {
        Text( "ADD_NEW_ADDRESS_NAVIGATION_TITLE", bundle: .module)
    }
    
    @ToolbarContentBuilder
    private func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .primaryAction, content: addAddressButton)
    }
    
    private func addAddressButton() -> some View {
        Button(action: viewModel.addAddressButtonTapped) {
            Label {
                Text("ADD_ADDRESS_BUTTON_TITLE", bundle: .module)
            } icon: {
                Image(systemName: "text.badge.plus")
            }
        }
    }
    
    private func searchSuggestions() -> some View {
        ForEach(viewModel.suggestions, content: suggestionView)
    }
    
    private func suggestionView(suggestion: Suggestion) -> some View {
        Button {
            viewModel.select(suggestion)
        } label: {
            Label(
                suggestion.address.street.rawValue,
                systemImage: "building.2.crop.circle"
            )
        }
    }
}

#if DEBUG
private extension Array where Element == Address {
    
    static let prevSearches: Self = [
        .init(street: .init("5th Ave, 123")),
    ]
    static let preview: Self = [
        .init(street: .init("Black Street, 123")),
        .init(street: .init("White Avenue, 456"))
    ]
}

private extension Array where Element == Suggestion {
    
    static let prevSearches: Self = [Address].prevSearches.map {
        .init(address: $0)
    }
    static let preview: Self = [Address].preview.map {
        .init(address: $0)
    }
}

import Combine

private extension AnyPublisher where Output == [Suggestion], Failure == Never {
    
    static let prevSearches: Self = Just(.prevSearches).eraseToAnyPublisher()
    static let preview: Self = Just(.preview).eraseToAnyPublisher()
}

import MapKit

struct AddNewAddressView_Previews: PreviewProvider {
    
    struct Demo<MapView: View>: View {
        let mapView: () -> MapView
        
        @StateObject private var viewModel: AddNewAddressViewModel = .init(
            getAddress: {},
            addAddress: { _ in },
            getSuggestions: { text in
                if text.isEmpty {
                    return .prevSearches
                } else {
                    return .preview
                }
            }
        )
        
        var body: some View {
            NavigationStack {
                AddNewAddressView(
                    viewModel: viewModel,
                    mapView: mapView
                )
            }
            .overlay(alignment: .bottom) {
                if let street = viewModel.address?.street.rawValue {
                    Text(street)
                } else {
                    Text("address not avail")
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    struct MapView: View {
        @State private var mapRect = MKMapRect.world
        
        var body: some View {
            Map(mapRect: $mapRect)
                .overlay(alignment: .bottomTrailing, content: getCurrentLocationButton)
        }
        
        private func getCurrentLocationButton() -> some View {
            Button(action: {  /* ?????????? */ }) {
                Label(
                    "CURRENT_LOCATION_BUTTON_TITLE",
                    systemImage: "location.fill"
                )
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .foregroundColor(.indigo)
                .padding(12)
                .background(.mint)
                .clipShape(Circle())
                .padding()
                .padding(.bottom)
                .padding(.bottom)
                .padding(.bottom)
            }
        }
    }
    
    static var previews: some View {
        Group {
            Demo() {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .overlay {
                        Text("TBD: Map + search + current location button")
                            .foregroundColor(.mint)
                    }
            }
            
            Demo(mapView: MapView.init)
        }
        .preferredColorScheme(.dark)
    }
}
#endif

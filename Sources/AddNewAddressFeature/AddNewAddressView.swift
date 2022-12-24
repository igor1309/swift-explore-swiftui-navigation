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
}

#if DEBUG
import MapKit

struct AddNewAddressView_Previews: PreviewProvider {
    
    struct Demo<MapView: View>: View {
        let mapView: () -> MapView
        
        var body: some View {
            NavigationStack {
                AddNewAddressView(
                    viewModel: .init(
                        getAddress: {},
                        addAddress: { _ in }
                    ),
                    mapView: mapView
                )
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

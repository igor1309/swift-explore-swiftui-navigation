//
//  AddNewAddressView.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import SwiftUI

public struct AddNewAddressView: View {
    
    @ObservedObject private var viewModel: AddNewAddressViewModel
    
    public init(viewModel: AddNewAddressViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            searchField()
                .padding(.horizontal)
            
            map()
                .ignoresSafeArea(edges: .bottom)
                .overlay(alignment: .bottomTrailing, content: getCurrentLocationButton)
        }
        .navigationTitle(Text("ADD_NEW_ADDRESS_NAVIGATION_TITLE", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: toolbar)
    }
    
    private func searchField() -> some View {
        TextField(
            text: .init(
                get: { viewModel.searchText },
                set: viewModel.setSearchText
            )
        ) {
            Text("SEARCH_FIELD", bundle: .module)
        }
    }
    
    private func map() -> some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .overlay {
                Text("TBD: Map + search + current location button")
                    .foregroundColor(.mint)
            }
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
    
    private func getCurrentLocationButton() -> some View {
        Button(action: viewModel.getCurrentLocationButtonTapped) {
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
        }
    }
    
    @ToolbarContentBuilder
    private func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .primaryAction, content: addAddressButton)
    }
}

struct AddNewAddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddNewAddressView(
                viewModel: .init(
                    getCurrentLocation: {},
                    addAddress: { _ in }
                )
            )
        }
        .preferredColorScheme(.dark)
    }
}

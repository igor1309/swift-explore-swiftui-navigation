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

struct AddNewAddressView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            AddNewAddressViewDemo()
            AddNewAddressViewDemo(mapView: MapView.init)
        }
        .preferredColorScheme(.dark)
    }
}

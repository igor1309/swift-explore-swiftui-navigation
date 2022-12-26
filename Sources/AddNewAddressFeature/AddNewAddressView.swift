//
//  AddNewAddressView.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import Combine
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
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .overlay(content: dismissSearchView)
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
        Text("ADD_NEW_ADDRESS_NAVIGATION_TITLE", bundle: .module)
    }
    
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
        .disabled(viewModel.address == nil)
    }
    
    private func dismissSearchView() -> some View {
        DismissSearchView(dismiss: viewModel.dismiss)
    }
    
    private struct DismissSearchView: View {
        @Environment(\.dismissSearch) private var dismissSearch
        
        let dismiss: PassthroughSubject<Void, Never>
        
        var body: some View {
            EmptyView()
                .onReceive(dismiss) { _ in dismissSearch() }
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

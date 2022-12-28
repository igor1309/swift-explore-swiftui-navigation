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
        .disabled(viewModel.addAddressButtonIsDisabled)
    }
    
    private func dismissSearchView() -> some View {
        DismissSearchView(dismiss: viewModel.dismissSearch)
    }
    
    private struct DismissSearchView: View {
        @Environment(\.dismissSearch) private var dismissSearch
        
        let dismiss: PassthroughSubject<Void, Never>
        
        var body: some View {
            EmptyView()
                .onReceive(dismiss) { _ in dismissSearch() }
        }
    }
    
    @ViewBuilder
    private func searchSuggestions() -> some View {
        switch viewModel.suggestions {
        case .none:
            EmptyView()
            
        case let .completions(completions):
            ForEach(completions, content: completionButton)
            
        case let .addresses(addresses):
            ForEach(addresses, content: addressButton)
        }
    }
    
    private func completionButton(completion: Completion) -> some View {
        Button {
            viewModel.completionButtonTapped(completion: completion)
        } label: {
            CompletionView(completion, attributes: .primary)
        }
        .containerShape(Rectangle())
        .buttonStyle(.plain)
    }
    
    private func addressButton(address: Address) -> some View {
        Button {
            viewModel.addressButtonTapped(address: address)
        } label: {
            PlainRow(address: address)
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

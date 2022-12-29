//
//  AddressMapSearchView.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import MapDomain
import SwiftUI

public struct AddressMapSearchView<MapView: View>: View {
    
    @ObservedObject private var viewModel: AddressMapSearchViewModel
    private let mapView: (Binding<CoordinateRegion>) -> MapView
    
    public init(
        viewModel: AddressMapSearchViewModel,
        mapView: @escaping (Binding<CoordinateRegion>) -> MapView
    ) {
        self.viewModel = viewModel
        self.mapView = mapView
    }
    
    public var body: some View {
        mapView(
            .init(
                get: { viewModel.region },
                set: viewModel.updateAndSearch(region:)
            )
        )
        .animation(.easeInOut, value: viewModel.region)
        .overlay(alignment: .center, content: target)
        .overlay(content: addressView)
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
    
    private func target() -> some View {
        Circle()
            .stroke(.blue, lineWidth: 4)
            .overlay{
                Circle()
                    .stroke(.white, lineWidth: 1)
            }
            .frame(width: 32, height: 32)
    }
    
    @ViewBuilder
    private func addressView() -> some View {
        switch viewModel.addressState {
        case .searching:
            ProgressView()
            
        case .none:
            Text("...")
            
        case let .address(address):
            Text(address.street.rawValue)
                .font(.subheadline.bold())
                .offset(x: 50, y: -32)
        }
    }
    
    private func dismissSearchView() -> some View {
        DismissSearchView(dismiss: viewModel.dismissSearch)
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

struct AddressMapSearchView_Previews: PreviewProvider {
    
    static func addressMapSearchView(
        viewModel: AddressMapSearchViewModel
    ) -> some View {
        NavigationStack {
            AddressMapSearchView(viewModel: viewModel, mapView: mapView)
                .ignoresSafeArea()
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .onAppear {
                    viewModel.updateAndSearch(region: .streetLondon)
                }
        }
    }
    
    static var previews: some View {
        Group {
            addressMapSearchView(viewModel: .preview)
            addressMapSearchView(viewModel: .delayedPreview)
            addressMapSearchView(viewModel: .failing)
        }
    }
    
    static func mapView(region: Binding<CoordinateRegion>) -> some View {
        Color.indigo
    }
}

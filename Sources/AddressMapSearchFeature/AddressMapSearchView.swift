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
        mapView(viewModel.region)
            .animation(.easeInOut, value: viewModel.state)
            .overlay(alignment: .center, content: target)
            .overlay(content: addressView)
            .overlay(content: dismissSearchView)
            .searchable(
                text: viewModel.searchText,
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
        switch viewModel.state.addressState {
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
        DismissSearchView(dismiss: viewModel.dismissSearchSubject)
    }
    
    @ViewBuilder
    private func searchSuggestions() -> some View {
        switch viewModel.state.search?.suggestions {
        case .none:
            EmptyView()
            
        case let .completions(completions):
            ForEach(completions, content: completionButton)
            
        case let .searchItems(searchItems):
            ForEach(searchItems, content: addressButton)
        }
    }
    
    private func completionButton(completion: Completion) -> some View {
        Button {
            viewModel.completionButtonTapped(completion)
        } label: {
            CompletionView(completion, attributes: .primary)
        }
        .containerShape(Rectangle())
        .buttonStyle(.plain)
    }
    
    private func addressButton(searchItem: SearchItem) -> some View {
        Button {
            viewModel.searchItemButtonTapped(searchItem)
        } label: {
            PlainRow(address: searchItem.address)
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
                    viewModel.updateRegion(to: .streetLondon)
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

//
//  AddressMapSearchView.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import MapDomain
import SwiftUI

struct AddressMapSearchView<MapView: View>: View {
    
    @ObservedObject private var viewModel: AddressMapSearchViewModel
    private let mapView: (Binding<CoordinateRegion>) -> MapView
    
    init(
        viewModel: AddressMapSearchViewModel,
        mapView: @escaping (Binding<CoordinateRegion>) -> MapView
    ) {
        self.viewModel = viewModel
        self.mapView = mapView
    }
    
    var body: some View {
        mapView(
            .init(
                get: { viewModel.region },
                set: viewModel.updateAndSearch(region:)
            )
        )
        .animation(.easeInOut, value: viewModel.region)
        .overlay(alignment: .center, content: target)
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
}

import MapKit

struct AddressMapSearchView_Previews: PreviewProvider {
    
    static let viewModel = AddressMapSearchViewModel(region: .townLondon)
    
    static var previews: some View {
        NavigationStack {
            AddressMapSearchView(
                viewModel: viewModel,
                mapView: mapView
            )
            .ignoresSafeArea()
        }
    }
    
    static func mapView(region: Binding<CoordinateRegion>) -> some View {
        Map(region: region)
    }
}

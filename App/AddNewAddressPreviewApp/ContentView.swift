//
//  ContentView.swift
//  AddNewAddressPreviewApp
//
//  Created by Igor Malyarov on 24.12.2022.
//

import AddNewAddressFeature
import AddressSearchOnMapFeature
import AddressSearchService
import Combine
import MapDomain
import SwiftUI

struct ContentView: View {
    
    private let composer: Composer
    
    init(composer: Composer) {
        self.composer = composer
    }
    
    var body: some View {
        AddNewAddressView(viewModel: composer.addNewAddressViewModel) {
            MapView(viewModel: composer.mapViewModel)
        }
    }
}

#if DEBUG
struct ContentViewDemo: View {
    @State private var address: AddressSearchOnMapFeature.Address?
    
    var body: some View {
        ContentView(
            composer: .init(
                region: .moscowNeighborhood,
                addAddress: addAddress
            )
        )
        .safeAreaInset(edge: .bottom, content: addressView)
    }
    
    private func addAddress(address: AddNewAddressFeature.Address) {
        self.address = address.searchAddress
    }
    
    private func addressView() -> some View {
        HStack {
            clearAddressButton()
            Spacer()
            addressLabel()
        }
        .font(.subheadline.bold())
        .padding(.top, 9)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
    }
    
    @ViewBuilder
    private func addressLabel() -> some View {
        if let address {
            Text("\(address.street) | \(address.city)")
        } else {
            Text("no address added")
                .foregroundColor(.red)
        }
    }
    
    private func clearAddressButton() -> some View {
        Button {
            self.address = nil
        } label: {
            Label("Clear address", systemImage: "trash")
                .labelStyle(.iconOnly)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle)
        .disabled(address == nil)
    }
}

// MARK: - Adapter

private extension AddNewAddressFeature.Address {
    
    var searchAddress: AddressSearchOnMapFeature.Address {
        .init(
            street: street.rawValue,
            city: city.rawValue
        )
    }
}
#endif

struct ContentView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        NavigationStack {
            ContentViewDemo()
        }
    }
}

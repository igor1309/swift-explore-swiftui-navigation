//
//  ContentView.swift
//  AddNewAddressPreviewApp
//
//  Created by Igor Malyarov on 24.12.2022.
//

import AddNewAddressFeature
import AddressSearchOnMapFeature
import SwiftUI

struct ContentView: View {
    @State private var address: AddressSearchOnMapFeature.Address?
    
    var body: some View {
        AddNewAddressUIComposer(
            composer: .moscowNeighborhood(
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

struct ContentView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        NavigationStack {
            ContentView()
        }
    }
}

//
//  AddNewAddressViewDemo.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import SwiftUI

#if DEBUG
public struct AddNewAddressViewDemo<MapView: View>: View {
    
    @StateObject private var viewModel: AddNewAddressViewModel = .init(
        getAddress: { .preview },
        getCompletions: { text in
            if text.isEmpty {
                return .prevSearches
            } else {
                return .preview
            }
        },
        addAddress: { _ in }
    )
    
    private let mapView: () -> MapView
    
    public init(mapView: @escaping () -> MapView) {
        self.mapView = mapView
    }
    
    public var body: some View {
        NavigationStack {
            AddNewAddressView(
                viewModel: viewModel,
                mapView: mapView
            )
        }
        .overlay(alignment: .bottom, content: streetView)
    }
    
    @ViewBuilder
    private func streetView() -> some View {
        if let street = viewModel.address?.street.rawValue {
            Text(street)
        } else {
            Text("address not avail")
                .foregroundColor(.red)
        }
    }
}

public struct FakeMap: View {
    
    public init() {}
    
    public var body: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .overlay {
                Text("TBD: Map + search + current location button")
                    .foregroundColor(.mint)
            }
    }
}

public extension AddNewAddressViewDemo where MapView == FakeMap {
    
    init() {
        self.init(mapView: FakeMap.init)
    }
}

struct AddNewAddressViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        AddNewAddressViewDemo()
            .preferredColorScheme(.dark)
    }
}
#endif

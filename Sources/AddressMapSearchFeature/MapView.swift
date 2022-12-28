//
//  MapView.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import MapKit
import SwiftUI

public struct MapView: View {
    
    @ObservedObject private var viewModel: MapViewModel
    
    public init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Map(
            region: .init(
                get: { viewModel.region },
                set: viewModel.update(region:)
            )
        )
        .animation(.easeInOut, value: viewModel.region)
        .overlay(content: circle)
        .overlay(content: addressView)
    }
    
    private func circle() -> some View {
        Circle()
            .stroke(.blue, lineWidth: 4)
            .overlay {
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
            Text(address.street)
                .font(.subheadline.bold())
                .offset(x: 50, y: -32)
        }
    }
}

struct Map_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            MapViewDemo(viewModel: .preview)
            MapViewDemo(viewModel: .failing)
            MapViewDemo(viewModel: .live())
        }
        .ignoresSafeArea()
    }
}
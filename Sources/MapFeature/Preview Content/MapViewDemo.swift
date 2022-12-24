//
//  MapViewDemo.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import SwiftUI

public struct MapViewDemo: View {
    @ObservedObject var viewModel: MapViewModel
    
    public init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        MapView(viewModel: viewModel)
            .safeAreaInset(edge: .bottom, content: watch)
    }
    
    private func watch() -> some View {
        VStack {
            Text(viewModel.street ?? "street n/a")
                .padding(2)
            
            Text(viewModel.center.latitude.formatted(.number))
            Text(viewModel.center.longitude.formatted(.number))
        }
        .font(.caption)
        .padding(.vertical)
        .monospaced()
    }
}

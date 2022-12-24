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
        Map(coordinateRegion: $viewModel.region)
            .overlay(content: circle)
            .safeAreaInset(edge: .bottom, content: center)
    }
    
    private func circle() -> some View {
        Circle()
            .stroke(.blue, lineWidth: 3)
            .overlay {
                Circle()
                    .stroke(.white, lineWidth: 1)
            }
            .frame(width: 32, height: 32)
    }
    
    private func center() -> some View {
        VStack {
            Text(viewModel.center.latitude.formatted(.number))
            Text(viewModel.center.longitude.formatted(.number))
        }
        .font(.caption)
        .padding(.vertical)
        .monospaced()
    }
}

struct Map_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: .init(region: .londonStreet))
            .ignoresSafeArea()
    }
}

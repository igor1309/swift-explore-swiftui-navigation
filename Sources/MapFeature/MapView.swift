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
            .overlay(content: street)
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
    
    private func street() -> some View {
        viewModel.street.map {
            Text($0)
                .font(.subheadline.bold())
                .offset(x: 50, y: -28)
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

//
//  MapViewDemo.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

import CasePaths
import SwiftUI
import Tagged

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
            Text((/MapViewModel.StreetState.street).extract(from: viewModel.streetState) ?? "street n/a")
                .padding(2)
            
            Text(viewModel.region.center.latitude.formatted(.number))
            Text(viewModel.region.center.longitude.formatted(.number))
        }
        .font(.caption)
        .padding(.bottom)
        .monospaced()
        .toolbar {
            ToolbarItem {
                Menu("Places") {
                    ForEach([Place].preview) { place in
                        Button(place.title) {
                            viewModel.update(region: place.region)
                        }
                    }
                }
            }
        }
    }
}

struct Place: Identifiable {
    typealias ID = Tagged<Self, UUID>
    
    let id: ID
    let title: String
    let region: CoordinateRegion
    
    init(id: ID = .init(.init()), title: String, region: CoordinateRegion) {
        self.id = id
        self.title = title
        self.region = region
    }
}

extension Place {
    
    static let barcelona: Self = .init(title: "Barcelona", region: .barcelonaStreet)
    static let london:    Self = .init(title: "London", region: .londonStreet)
    static let moscow:    Self = .init(title: "Moscow", region: .moscowStreet)
    static let paris:     Self = .init(title: "Paris", region: .init(center: .paris, span: .street))
    static let rome:      Self = .init(title: "Rome", region: .init(center: .rome, span: .street))
}

extension Array where Element == Place {
    
    static let preview: Self = [.barcelona, .london, .moscow, .paris, .rome]
}

struct MapViewDemo_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationStack {
            MapViewDemo(viewModel: .preview)
                .ignoresSafeArea()
        }
    }
}

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
            .overlay(alignment: .bottom) {
                Text(String(describing: viewModel.region))
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background()
                    .monospaced()
            }
    }
}

struct Map_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: .init(region: .londonNeighborhood))
            .ignoresSafeArea()
    }
}

#if DEBUG
extension MKCoordinateRegion {
    
    static let barcelonaNeighborhood: Self = .init(
        center: .barcelona,
        span: .neighborhood
    )
    static let londonCity: Self = .init(
        center: .london,
        span: .city
    )
    static let londonTown: Self = .init(
        center: .london,
        span: .town
    )
    static let londonNeighborhood: Self = .init(
        center: .london,
        span: .neighborhood
    )
}

extension CLLocationCoordinate2D {
    
    static let barcelona:    Self = .init(41.390205, 2.154007)
    static let london:       Self = .init(51.507222, -0.1275)
    static let paris:        Self = .init(48.8567, 2.3508)
    static let rome:         Self = .init(41.9, 12.5)
    static let washingtonDC: Self = .init(38.895111, -77.036667)
    
    private init(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
        self.init(latitude: latitude, longitude: longitude)
    }
}

extension MKCoordinateSpan {
    
    static var regional:     Self = .init(8,    8)
    static var area:         Self = .init(2,    2)
    static var city:         Self = .init(0.5,  0.5)
    static var town:         Self = .init(0.1,  0.1)
    static var neighborhood: Self = .init(0.01, 0.01)
    
    private init(
        _ latitudeDelta: CLLocationDegrees,
        _ longitudeDelta: CLLocationDegrees
    ) {
        self.init(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    }
}
#endif

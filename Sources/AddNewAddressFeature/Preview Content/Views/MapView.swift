//
//  MapView.swift
//  
//
//  Created by Igor Malyarov on 24.12.2022.
//

#if DEBUG
import MapKit
import SwiftUI

struct MapView: View {
    @State private var mapRect = MKMapRect.world
    
    var body: some View {
        Map(mapRect: $mapRect)
            .overlay(alignment: .bottomTrailing, content: getCurrentLocationButton)
    }
    
    private func getCurrentLocationButton() -> some View {
        Button(action: {  /* ?????????? */ }) {
            Label(
                "CURRENT_LOCATION_BUTTON_TITLE",
                systemImage: "location.fill"
            )
            .labelStyle(.iconOnly)
            .imageScale(.large)
            .foregroundColor(.indigo)
            .padding(12)
            .background(.mint)
            .clipShape(Circle())
            .padding()
            .padding(.bottom)
            .padding(.bottom)
            .padding(.bottom)
        }
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
#endif

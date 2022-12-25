//
//  Map+ext.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

import MapKit
import SwiftUI

extension Map {
    
    init(
        region: Binding<CoordinateRegion>//,
//        annotationItems: <#T##RandomAccessCollection#>,
//        annotationContent: <#T##(Identifiable) -> MapAnnotationProtocol#>
    )  where Content == _DefaultMapContent {
        self.init(
            coordinateRegion: region.mkCoordinateRegion//,
//            annotationItems: <#T##RandomAccessCollection#>,
//            annotationContent: <#T##(Identifiable) -> MapAnnotationProtocol#>
        )
    }
}

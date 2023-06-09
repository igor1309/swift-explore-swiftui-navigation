//
//  CoordinateRegion.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

public struct CoordinateRegion: Equatable {

    /// The center point of the region.
    public var center: LocationCoordinate2D

    /// The horizontal and vertical span representing the amount of map to display.
    public var span: CoordinateSpan
    
    public init(center: LocationCoordinate2D, span: CoordinateSpan) {
        self.center = center
        self.span = span
    }
}

//
//  Coordinate+isClose.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

func isClose(
    _ lhs: LocationCoordinate2D,
    to rhs: LocationCoordinate2D,
    withAccuracy accuracy: LocationDegrees = 0.0001
) -> Bool {
    abs(lhs.latitude.distance(to: rhs.latitude)) < accuracy
    && abs(lhs.longitude.distance(to: rhs.longitude)) < accuracy
}

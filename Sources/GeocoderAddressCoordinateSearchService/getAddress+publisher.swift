//
//  getAddress+publisher.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import Combine
import MapDomain

public extension GeocoderAddressCoordinateSearch {
    
    func getAddress(
        from coordinate: LocationCoordinate2D
    ) -> AnyPublisher<Address?, Never> {
        Deferred {
            Future { promise in
                Task {
                    let address = await self.getAddress(from: coordinate)
                    promise(.success(address))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

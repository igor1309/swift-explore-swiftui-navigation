//
//  Composer.swift
//  AddNewAddressPreviewApp
//
//  Created by Igor Malyarov on 27.12.2022.
//

import AddNewAddressFeature
import AddressSearchOnMapFeature
import AddressSearchService
import MapDomain

final class Composer {
    
    let addNewAddressViewModel: AddNewAddressViewModel
    let mapViewModel: MapViewModel
    
    var addAddress: (AddNewAddressViewModel.AddAddress)?
    
    init(
        region: CoordinateRegion,
        addAddress: @escaping AddNewAddressViewModel.AddAddress
    ) {
        let mapViewModel = MapViewModel.live(region: region)
        let completer = LocalSearchCompleter()
        
        self.mapViewModel = mapViewModel
        
        self.addNewAddressViewModel = .init(
            getAddress: {
                mapViewModel.addressPublisher()
                    .map(\.featureAddress)
                    .eraseToAnyPublisher()
            },
            getCompletions: { text in
                completer.searchCompletions(text)
                    .map(\.searchCompletions)
                    .map { $0.map(\.completion) }
                    .eraseToAnyPublisher()
            },
            addAddress: addAddress
        )
    }
}

extension Composer {
    
    static func moscowNeighborhood(
        addAddress: @escaping AddNewAddressViewModel.AddAddress
    ) -> Composer {
        .init(region: .moscowNeighborhood, addAddress: addAddress)
    }
}

// MARK: - Adapters

private extension Swift.Optional where Wrapped == AddressSearchOnMapFeature.Address {
    
    var featureAddress: AddNewAddressFeature.Address? {
        guard let self else {
            return nil
        }
        
        return self.featureAddress
    }
}

private extension AddressSearchOnMapFeature.Address {
    
    var featureAddress: AddNewAddressFeature.Address {
        .init(
            street: .init(rawValue: street),
            city: .init(rawValue: city)
        )
    }
}

private extension CompletionsResult {
    
    var searchCompletions: [LocalSearchCompletion] {
        switch self {
        case .failure:
            return []
            
        case let .success(searchCompletions):
            return searchCompletions
        }
    }
}

private extension LocalSearchCompletion {
    
    var completion: Completion {
        .init(
            title: title,
            subtitle: subtitle,
            titleHighlightRanges: titleHighlightRanges,
            subtitleHighlightRanges: subtitleHighlightRanges)
    }
}

//
//  Composer.swift
//  AddNewAddressPreviewApp
//
//  Created by Igor Malyarov on 27.12.2022.
//

import AddNewAddressFeature
import AddressSearchOnMapFeature
import AddressSearchService
import Combine
import MapDomain

typealias SearchAddress = AddressSearchService.Address
typealias FeatureAddress = AddNewAddressFeature.Address
typealias MapAddress = AddressSearchOnMapFeature.Address

typealias AddAddress = AddNewAddressViewModel.AddAddress
typealias Search = AddNewAddressViewModel.Search
typealias GetAddress = AddNewAddressViewModel.GetAddress
typealias GetCompletions = AddNewAddressViewModel.GetCompletions

typealias SearchAddressesPublisher = AnyPublisher<Result<[SearchAddress], Error>, Never>
typealias SearchAddresses = (Completion, CoordinateRegion) -> SearchAddressesPublisher

typealias SearchPublisher = AddNewAddressViewModel.SearchPublisher

#warning("add abstract interfaces and extract this whole thing into separate module")
final class Composer {
    
    let addNewAddressViewModel: AddNewAddressViewModel
    let mapViewModel: MapViewModel
    
    var addAddress: (AddAddress)?
    
    init(
        region: CoordinateRegion,
        searchAddresses: @escaping SearchAddresses,
        searchCompletions: @escaping (String) -> CompletionsPublisher,
        addAddress: @escaping AddAddress
    ) {
        let mapViewModel = MapViewModel.live(region: region)
        
        let getAddress: GetAddress = {
            mapViewModel.addressPublisher()
                .map(\.featureAddress)
                .eraseToAnyPublisher()
        }
        
        let getCompletions: GetCompletions = { text in
            searchCompletions(text)
                .map(\.searchCompletions)
                .map { $0.map(\.completion) }
                .eraseToAnyPublisher()
        }
        
        let search: Search = { (completion: Completion) in
            searchAddresses(completion, region)
                .map(\.addresses)
                .map { $0.map(\.featureAddress) }
                .eraseToAnyPublisher()
        }
        
        self.mapViewModel = mapViewModel
        
        self.addNewAddressViewModel = .init(
            getAddress: getAddress,
            getCompletions: getCompletions,
            search: search,
            addAddress: addAddress
        )
    }
}

extension Composer {
    
    static func neighborhoodMoscow(
        addAddress: @escaping AddAddress
    ) -> Composer {
        .init(
            region: .neighborhoodMoscow,
            searchAddresses: LocalTextSearchClient.live.searchAddresses,
            searchCompletions: LocalSearchCompleter().searchCompletions,
            addAddress: addAddress
        )
    }
}

// MARK: - Adapters

private extension LocalTextSearchClient {
    
    func searchAddresses(
        completion: Completion,
        region: CoordinateRegion?
    ) -> SearchAddressesPublisher {
        searchAddresses(
            completion.title + " " + completion.subtitle,
            region: region
        )
    }
}

// MARK: - Address Adapters

private extension MapAddress {
    
    var featureAddress: FeatureAddress {
        .init(
            street: .init(rawValue: street),
            city: .init(rawValue: city)
        )
    }
}

private extension SearchAddress {
    
    var featureAddress: FeatureAddress {
        .init(
            street: .init(rawValue: street),
            city: .init(rawValue: city)
        )
    }
}

// MARK: - Adapters

private extension Swift.Optional where Wrapped == MapAddress {
    
    var featureAddress: FeatureAddress? {
        guard let self else {
            return nil
        }
        
        return self.featureAddress
    }
}

// MARK: - Result Adapters

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

private extension Result where Success == [SearchAddress] {
    
    var addresses: [SearchAddress] {
        switch self {
        case .failure:
            return []
            
        case let .success(addresses):
            return addresses
        }
    }
}

// MARK: - Completion Adapters

private extension LocalSearchCompletion {
    
    var completion: Completion {
        .init(
            title: title,
            subtitle: subtitle,
            titleHighlightRanges: titleHighlightRanges,
            subtitleHighlightRanges: subtitleHighlightRanges
        )
    }
}

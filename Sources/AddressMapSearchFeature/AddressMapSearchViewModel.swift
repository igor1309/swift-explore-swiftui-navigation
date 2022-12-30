//
//  AddressMapSearchViewModel.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import CasePaths
import Combine
import CombineSchedulers
import Foundation
import MapDomain

#warning("replace protocols with closures")

public protocol CoordinateSearch {
    
    typealias AddressResult = Result<Address, Error>
    typealias AddressResultPublisher = AnyPublisher<AddressResult, Never>
    
    func search(for coordinate: LocationCoordinate2D) -> AddressResultPublisher
}

public protocol SearchCompleter {
    
    typealias CompletionsResult = Result<[Completion], Error>
    typealias CompletionsResultPublisher = AnyPublisher<CompletionsResult, Never>
    
    func complete(query: String) -> CompletionsResultPublisher
}

public protocol LocalSearch {
    
    typealias SearchResult = Result<[SearchItem], Error>
    typealias SearchResultPublisher = AnyPublisher<SearchResult, Never>
    
    func search(completion: Completion) -> SearchResultPublisher
}

public final class AddressMapSearchViewModel: ObservableObject {
    
    @Published public private(set) var state: AddressMapSearchState
    
    public let dismissSearchSubject = PassthroughSubject<Void, Never>()
    
    private let coordinateSearchSubject = PassthroughSubject<CoordinateRegion, Never>()
    private let searchTextSubject = PassthroughSubject<String, Never>()
    private let completionSubject = PassthroughSubject<Completion, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    public typealias IsClose = (LocationCoordinate2D, LocationCoordinate2D) -> Bool
    
    public init(
        initialRegion: CoordinateRegion,
        coordinateSearch: CoordinateSearch,
        isClose: @escaping IsClose,
        searchCompleter: SearchCompleter,
        localSearch: LocalSearch,
        scheduler: AnySchedulerOf<DispatchQueue> = .main
    ) {
        self.state = .init(region: initialRegion)
        
        // a publisher with side-effects: state changes inside the pipeline
        // see `handleEvents`
        let addressByCoordinateSearch: CoordinateSearch.AddressResultPublisher = coordinateSearchSubject
            .debounce(for: 0.5, scheduler: scheduler)
            .handleEvents(receiveOutput: { [weak self] in
                #warning("would this `handleEvents` be enough for UI to update without errors? Or need additional `receive(on:)` dancing?")
                self?.state.region = $0
            })
            .map(\.center)
            .removeDuplicates(by: isClose)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.state.addressState = .searching
            })
            .flatMap(coordinateSearch.search(for:))
            .eraseToAnyPublisher()
        
        addressByCoordinateSearch
            .receive(on: scheduler)
            .sink { [weak self] in
                self?.updateAddressState(with: $0)
            }
            .store(in: &cancellables)
        
        searchTextSubject
            .debounce(for: 0.3, scheduler: scheduler)
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] in
                self?.state.search = .some(.init(searchText: $0))
            })
            .flatMap(searchCompleter.complete(query:))
            .receive(on: scheduler)
            .sink { [weak self] in
                self?.updateSearchState(with: $0)
            }
            .store(in: &cancellables)
        
        completionSubject
            .flatMap(localSearch.search(completion:))
            .receive(on: scheduler)
            .sink { [weak self] in
                self?.updateSearchState(with: $0)
            }
            .store(in: &cancellables)
    }
    
    public func updateRegion(to region: CoordinateRegion) {
        coordinateSearchSubject.send(region)
    }
    
    public func handleIsSearching(_ isSearching: Bool) {
        switch (state.search, isSearching) {
        case (.some, true),
            (.none, false):
            break
            
        case (.some, false):
            state.search = .none
            
        case (.none, true):
            state.search = .some(.init())
        }
    }
    
    public func dismissSearch() {
        guard case .some = state.search else {
            return
        }
        state.search = .none
    }
    
    /// The `setter` part of the `searchText` binding.
    public func setSearchText(to text: String) {
        searchTextSubject.send(text)
    }
    
    public func completionButtonTapped(_ completion: Completion) {
        completionSubject.send(completion)
    }
    
    public func searchItemButtonTapped(_ searchItem: SearchItem) {
        state = .init(
            region: searchItem.region,
            search: .none,
            addressState: .address(searchItem.address)
        )
        dismissSearchSubject.send(())
    }
    
    private func updateAddressState(with result: CoordinateSearch.AddressResult) {
        switch result {
        case .failure:
            state.addressState = .none
            
        case let .success(address):
            state.addressState = .address(address)
        }
    }
    
    private func updateSearchState(with result: SearchCompleter.CompletionsResult) {
        switch result {
        case .failure:
            state.search?.suggestions = .completions([])

        case let .success(completions):
            state.search?.suggestions = .completions(completions)
        }
    }
    
    private func updateSearchState(with result: LocalSearch.SearchResult) {
        switch result {
        case .failure:
            state.search?.suggestions = .searchItems([])

        case let .success(searchItems):
            state.search?.suggestions = .searchItems(searchItems)
        }
    }
}

// MARK: - View Bindings

import SwiftUI

extension AddressMapSearchViewModel {
    
    var region: Binding<CoordinateRegion> {
        .init(
            get: { self.state.region },
            set: updateRegion(to:)
        )
    }
    
    var searchText: Binding<String> {
        .init(
            get: { self.state.search?.searchText ?? "" },
            set: setSearchText
        )
    }
}

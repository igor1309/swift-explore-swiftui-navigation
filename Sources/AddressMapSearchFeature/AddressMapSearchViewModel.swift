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

extension AddressMapSearchState {
    
    typealias Effect = AnyPublisher<Action, Never>
    
    static func reducer(_ state: Self, _ action: Action) -> Self {
        var state = state
        
        switch action {
        case let .setSearchText(text):
            state.search = .some(.init(searchText: text))
            
        case let .setRegion(region):
            state.region = region
            
        case let .setCompletions(result):
            switch result {
            case .failure:
                state.search?.suggestions = .completions([])
                
            case let .success(completions):
                state.search?.suggestions = .completions(completions)
            }
            
        case let .setSearchItems(result):
            switch result {
            case .failure:
                state.search?.suggestions = .searchItems([])
                
            case let .success(searchItems):
                state.search?.suggestions = .searchItems(searchItems)
            }
            
        case let .setStateOn(searchItem):
            state = .init(
                region: searchItem.region,
                search: nil,
                addressState: .address(searchItem.address)
            )
            
        case let .setAddress(result):
            switch result {
            case .failure:
                state.addressState = .none
                
            case let .success(address):
                state.addressState = .address(address)
            }
        }
        
        return state
    }
    
    enum Action {
        case setRegion(CoordinateRegion)
        case setSearchText(String)
        case setCompletions(SearchCompleter.CompletionsResult)
        case setSearchItems(LocalSearch.SearchResult)
        case setStateOn(SearchItem)
        case setAddress(CoordinateSearch.AddressResult)
    }

}

public final class AddressMapSearchViewModel: ObservableObject {
    
    @Published public private(set) var state: AddressMapSearchState
    
    public let dismissSearchSubject = PassthroughSubject<Void, Never>()
    
    private let inputSubject = PassthroughSubject<Input, Never>()
    private let iinputSubject = PassthroughSubject<Input, Never>()
    
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
        
        // a pipeline with side-effects: state changes inside the pipeline
        // see `handleEvents`
        iinputSubject
            .compactMap(/Input.region)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.state.addressState = .searching
            })
            .debounce(for: 0.5, scheduler: scheduler)
            .handleEvents(receiveOutput: { [weak self] in
#warning("would this `handleEvents` be enough for UI to update without errors? Or need additional `receive(on:)` dancing?")
                self?.state.region = $0
#warning("add test for")
                //                self?.state.addressState = .searching
            })
            .map(\.center)
            .removeDuplicates(by: isClose)
        //            .handleEvents(receiveOutput: { [weak self] _ in
        //                self?.state.addressState = .searching
        //            })
            .flatMap(coordinateSearch.search(for:))
            .receive(on: scheduler)
            .sink { [weak self] in
                self?.updateAddressState(with: $0)
            }
            .store(in: &cancellables)
        
        iinputSubject
            .compactMap(/Input.searchText)
            .handleEvents(receiveOutput: { [weak self] in
                self?.state.search = .some(.init(searchText: $0))
            })
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: scheduler)
            .flatMap(searchCompleter.complete(query:))
            .receive(on: scheduler)
            .sink { [weak self] in
                self?.updateSearchState(with: $0)
            }
            .store(in: &cancellables)
        
        iinputSubject
            .compactMap(/Input.completion)
            .flatMap(localSearch.search(completion:))
            .receive(on: scheduler)
            .sink { [weak self] in
                self?.updateSearchState(with: $0)
            }
            .store(in: &cancellables)
        
        inputSubject
            .flatMap { /* capture list*/ input -> AnyPublisher<AddressMapSearchState.Action, Never> in
                switch input {
                case let .region(region):
                    #warning("debounce? remove duplicates? handle events??")
                    return coordinateSearch.search(for: region.center)
                        .map(AddressMapSearchState.Action.setAddress)
                        .eraseToAnyPublisher()
                    
                case let .searchText(text):
                    #warning("debounce? remove duplicates? handle events??")
                    return searchCompleter.complete(query: text)
                        .map(AddressMapSearchState.Action.setCompletions)
                        .eraseToAnyPublisher()
                    
                case let .completion(completion):
                    #warning("debounce? remove duplicates? handle events??")
                    return localSearch.search(completion: completion)
                        .map(AddressMapSearchState.Action.setSearchItems)
                        .eraseToAnyPublisher()
                    
                case let .searchItem(searchItem):
                    #warning("debounce? remove duplicates? handle events??")
                    return Just(searchItem)
                        .map(AddressMapSearchState.Action.setStateOn)
                        .eraseToAnyPublisher()
                }
            }
            .scan(state, AddressMapSearchState.reducer)
            .receive(on: scheduler)
            .assign(to: &$state)
    }
    
    private func send(_ input: Input) {
        inputSubject.send(input)
    }
    
    #warning("remove as unused")
    private func updateAddressState(with result: CoordinateSearch.AddressResult) {
        switch result {
        case .failure:
            state.addressState = .none
            
        case let .success(address):
            state.addressState = .address(address)
        }
    }
    
    #warning("remove as unused")
    private func updateSearchState(with result: SearchCompleter.CompletionsResult) {
        switch result {
        case .failure:
            state.search?.suggestions = .completions([])
            
        case let .success(completions):
            state.search?.suggestions = .completions(completions)
        }
    }
    
    #warning("remove as unused")
    private func updateSearchState(with result: LocalSearch.SearchResult) {
        switch result {
        case .failure:
            state.search?.suggestions = .searchItems([])
            
        case let .success(searchItems):
            state.search?.suggestions = .searchItems(searchItems)
        }
    }
    
    enum Input {
        case region(CoordinateRegion)
        case searchText(String)
        case completion(Completion)
        case searchItem(SearchItem)
    }
    
//    enum Action {
//        // case setState(AddressMapSearchState)
//        case setAddress(CoordinateSearch.AddressResult)
//        case setRegion(CoordinateRegion)
//        case setSearchText(String)
//        case setCompletions(SearchCompleter.CompletionsResult)
//        case setSearchItems(LocalSearch.SearchResult)
//        case setStateOn(SearchItem)
//    }
}

// MARK: - ????
extension AddressMapSearchViewModel {
    
    func handleIsSearching(_ isSearching: Bool) {
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
    
    func dismissSearch() {
        guard case .some = state.search else {
            return
        }
        state.search = .none
    }
}

// MARK: - Public endpoints.

public extension AddressMapSearchViewModel {
    
    func updateRegion(to region: CoordinateRegion) {
        send(.region(region))
    }
    
    /// The `setter` part of the `searchText` binding.
    func setSearchText(to text: String) {
        send(.searchText(text))
    }
    
    func completionButtonTapped(_ completion: Completion) {
        send(.completion(completion))
    }
    
    func searchItemButtonTapped(_ searchItem: SearchItem) {
        dismissSearchSubject.send(())
        DispatchQueue.main.async { [weak self] in
            self?.state = .init(
                region: searchItem.region,
                search: .none,
                addressState: .address(searchItem.address)
            )
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

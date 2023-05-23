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
    
    private let inputSubject = PassthroughSubject<Input, Never>()
    private let iinputSubject = PassthroughSubject<Input, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    public typealias IsClose = (LocationCoordinate2D, LocationCoordinate2D) -> Bool
    
    private let coordinateSearch: CoordinateSearch
    private let searchCompleter: SearchCompleter
    private let localSearch: LocalSearch
    private let scheduler: AnySchedulerOf<DispatchQueue>
    
    public init(
        initialRegion: CoordinateRegion,
        coordinateSearch: CoordinateSearch,
        isClose: @escaping IsClose,
        searchCompleter: SearchCompleter,
        localSearch: LocalSearch,
        scheduler: AnySchedulerOf<DispatchQueue> = .main
    ) {
        self.state = .init(region: initialRegion)
        self.coordinateSearch = coordinateSearch
        self.searchCompleter = searchCompleter
        self.localSearch = localSearch
        self.scheduler = scheduler
        
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
        
       let p = inputSubject
            .flatMap { /* capture list*/ input -> Effect in
                switch input {
                case let .region(region):
                    #warning("debounce? remove duplicates? handle events??")
                    return coordinateSearch.search(for: region.center)
                        .map(Action.setAddress)
                        .eraseToAnyPublisher()
                    
                case let .searchText(text):
                    #warning("debounce? remove duplicates? handle events??")
                    return searchCompleter.complete(query: text)
                        .map(Action.setCompletions)
                        .eraseToAnyPublisher()
                    
                case let .completion(completion):
                    #warning("debounce? remove duplicates? handle events??")
                    return localSearch.search(completion: completion)
                        .map(Action.setSearchItems)
                        .eraseToAnyPublisher()
                    
                case let .searchItem(searchItem):
                    #warning("debounce? remove duplicates? handle events??")
                    return Just(searchItem)
                        .map(Action.setStateOn)
                        .eraseToAnyPublisher()
                }
            }
            //.scan(state, AddressMapSearchState.reducer)
            .receive(on: scheduler)
            //.assign(to: &$state)
            .eraseToAnyPublisher()
    }
    
//    private func send(_ input: Input) {
//        inputSubject.send(input)
//    }
    
    private var effectCancellables = Set<AnyCancellable>()
    
    private func send(_ action: Action) {
        let effects = reducer(&state, action)
        effects.forEach { effect in
            var effectCancellable: AnyCancellable?
            var didFinish = false
            effectCancellable = effect.sink(
                receiveCompletion: { [weak self] _ in
                    didFinish = true
                    guard let effectCancellable else { return }
                    self?.cancellables.remove(effectCancellable)
                },
                receiveValue: self.send
            )
            if !didFinish, let effectCancellable {
                self.cancellables.insert(effectCancellable)
            }
        }
    }
    
    typealias Effect = AnyPublisher<Action, Never>
    
    func reducer(
        _ state: inout AddressMapSearchState,
        _ action: Action
    ) -> [Effect] {
        switch action {
        case let .setSearchText(text):
            state.search = .some(.init(searchText: text))
            return [
                Just(text)
                    // .removeDuplicates()
                    // .debounce(for: 0.3, scheduler: scheduler)
                    .flatMap(searchCompleter.complete(query:))
                    .map(Action.setCompletions)
                    .receive(on: scheduler)
                    .eraseToAnyPublisher()
            ]
            
        case let .setRegion(region):
            state.region = region
            return [
                Just(AddressMapSearchState.AddressState.searching)
                    .map(Action.setAddressState)
                    .eraseToAnyPublisher(),
//                Just(region)
                // .debounce(for: 0.5, scheduler: scheduler)
//                    .map(\.center)
                    // .removeDuplicates(by: isClose)
//                    .flatMap(coordinateSearch.search(for:))
                coordinateSearch.search(for: region.center)
                    .map(Action.setAddress)
                    .receive(on: scheduler)
                    .eraseToAnyPublisher()
            ]
            
        case let .setAddressState(addressState):
            state.addressState = addressState
            return []
            
        case let .setCompletions(result):
            switch result {
            case .failure:
                state.search?.suggestions = .completions([])
                
            case let .success(completions):
                state.search?.suggestions = .completions(completions)
            }
            return []
            
        case let .select(completion):
            return [
                Just(completion)
                    .flatMap(localSearch.search(completion:))
                    .map(Action.setSearchItems)
                    .receive(on: scheduler)
                    .eraseToAnyPublisher()
            ]
            
        case let .setSearchItems(result):
            switch result {
            case .failure:
                state.search?.suggestions = .searchItems([])
                
            case let .success(searchItems):
                state.search?.suggestions = .searchItems(searchItems)
            }
            return []
            
        case let .setStateOn(searchItem):
            state = .init(
                region: searchItem.region,
                search: nil,
                addressState: .address(searchItem.address)
            )
            return []
            
        case let .setAddress(result):
            switch result {
            case .failure:
                state.addressState = .none
                
            case let .success(address):
                state.addressState = .address(address)
            }
            return []
        }
    }
    
    enum Action {
        case setRegion(CoordinateRegion)
        case setSearchText(String)
        case setAddressState(AddressMapSearchState.AddressState)
        case setCompletions(SearchCompleter.CompletionsResult)
        case select(Completion)
        case setSearchItems(LocalSearch.SearchResult)
        case setStateOn(SearchItem)
        case setAddress(CoordinateSearch.AddressResult)
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
        send(.setRegion(region))
    }
    
    /// The `setter` part of the `searchText` binding.
    func setSearchText(to text: String) {
        send(.setSearchText(text))
    }
    
    func completionButtonTapped(_ completion: Completion) {
        send(.select(completion))
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

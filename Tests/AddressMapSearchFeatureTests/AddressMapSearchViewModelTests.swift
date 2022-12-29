//
//  AddressMapSearchViewModelTests.swift
//  
//
//  Created by Igor Malyarov on 29.12.2022.
//

import CasePaths
import Combine
import CombineSchedulers
import MapDomain
import Tagged
import XCTest

struct AddressMapSearchState: Equatable {
    
    /// A region that corresponds to an area to display on the map.
    var region: CoordinateRegion
    
    /// A search state.
    var search: Search?
    
    /// A state of address.
    var addressState: AddressState?
    
    struct Search: Equatable {
        
        /// The text to display and edit in the search field.
        var searchText: String = ""
        
        var suggestions: Suggestions?
    }
    
    enum AddressState: Equatable {
        case searching
        case address(Address)
    }
    
    enum Suggestions: Equatable {
        case completions([Completion])
        case searchItems([SearchItem])
    }
}

struct Address: Equatable {}

typealias AddressResult = Result<Address, Error>
typealias AddressResultPublisher = AnyPublisher<AddressResult, Never>

protocol CoordinateSearch {
    func search(for coordinate: LocationCoordinate2D) -> AddressResultPublisher
}

struct Completion: Equatable, Identifiable {
    
    typealias ID = Tagged<Self, UUID>
    
    let id: ID
    
    init(id: ID = .init()) {
        self.id = id
    }
}

typealias CompletionsResult = Result<[Completion], Error>
typealias CompletionsResultPublisher = AnyPublisher<CompletionsResult, Never>

protocol SearchCompleter {
    func complete(query: String) -> CompletionsResultPublisher
}

struct SearchItem: Equatable, Identifiable {
    
    typealias ID = Tagged<Self, UUID>
    
    let id: ID
    let address: Address
    let region: CoordinateRegion
    
    init(id: ID = .init(), address: Address, region: CoordinateRegion) {
        self.id = id
        self.address = address
        self.region = region
    }
}

typealias SearchResult = Result<[SearchItem], Error>
typealias SearchResultPublisher = AnyPublisher<SearchResult, Never>

protocol LocalSearch {
    func search(completion: Completion) -> SearchResultPublisher
}

private final class AddressMapSearchViewModel: ObservableObject {
    
    @Published private(set) var state: AddressMapSearchState
    
    private let coordinateSearchSubject = PassthroughSubject<CoordinateRegion, Never>()
    private let searchTextSubject = PassthroughSubject<String, Never>()
    private let completionSubject = PassthroughSubject<Completion, Never>()
    let dismissSearchSubject = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    typealias IsClose = (LocationCoordinate2D, LocationCoordinate2D) -> Bool
    
    init(
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
        let addressByCoordinateSearch: AnyPublisher<AddressResult, Never> = coordinateSearchSubject
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
    
    func updateRegion(to region: CoordinateRegion) {
        coordinateSearchSubject.send(region)
    }
    
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
    
    /// The `setter` part of the `searchText` binding.
    func setSearchText(to text: String) {
        searchTextSubject.send(text)
    }
    
    func completionButtonTapped(_ completion: Completion) {
        completionSubject.send(completion)
    }
    
    func searchItemButtonTapped(_ searchItem: SearchItem) {
        state = .init(
            region: searchItem.region,
            search: .none,
            addressState: .address(searchItem.address)
        )
        dismissSearchSubject.send(())
    }
    
    private func updateAddressState(with result: AddressResult) {
        switch result {
        case .failure:
            state.addressState = .none
            
        case let .success(address):
            state.addressState = .address(address)
        }
    }
    
    private func updateSearchState(with result: CompletionsResult) {
        switch result {
        case .failure:
            state.search?.suggestions = .completions([])

        case let .success(completions):
            state.search?.suggestions = .completions(completions)
        }
    }
    
    private func updateSearchState(with result: SearchResult) {
        switch result {
        case .failure:
            state.search?.suggestions = .searchItems([])

        case let .success(searchItems):
            state.search?.suggestions = .searchItems(searchItems)
        }
    }
}

final class AddressMapSearchViewModelTests: XCTestCase {
    
    func test_init_shouldSetRegion_toInitialRegion() {
        let initialRegion: CoordinateRegion = .test
        let (sut, spy) = makeSUT(initialRegion: initialRegion)
        
        XCTAssertEqual(spy.values, [.state(region: initialRegion)])
        XCTAssertNotNil(sut)
    }
    
    func test_init_shouldSetSearch_toNil() {
        let (sut, spy) = makeSUT()
        
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
        ])
        XCTAssertNotNil(sut)
    }
    
    func test_init_shouldSetAddressState_toNil() {
        let (sut, spy) = makeSUT()
        
        XCTAssertEqual(spy.values, [
            .state(region: .test, addressState: .none),
        ])
        XCTAssertNotNil(sut)
    }
    
    func test_regionChange_shouldInvokeCoordinateSearch() {
        let coordinateSearchSpy = CoordinateSearchSpy()
        let scheduler = DispatchQueue.test
        let (sut, _) = makeSUT(
            coordinateSearch: coordinateSearchSpy,
            scheduler: scheduler.eraseToAnyScheduler()
        )
        XCTAssertEqual(coordinateSearchSpy.calls, [])
        
        sut.updateRegion(to: .any)
        scheduler.advance(by: .milliseconds(500))
        
        XCTAssertEqual(coordinateSearchSpy.calls, [.any])
    }
    
    func test_regionChange_shouldChangeAddressState_onSuccessfulCoordinateSearch() {
        let scheduler = DispatchQueue.test
        let (sut, spy) = makeSUT(scheduler: scheduler.eraseToAnyScheduler())
        XCTAssertEqual(spy.values, [
            .state(region: .test, addressState: .none),
        ])
        
        sut.updateRegion(to: .any)
        scheduler.advance(by: .milliseconds(500))
        
        XCTAssertEqual(spy.values, [
            .state(region: .test, addressState: .none),
            .state(region: .any,  addressState: .none),
            .state(region: .any,  addressState: .searching),
            .state(region: .any,  addressState: .address(.test)),
        ])
    }
    
    func test_regionChange_shouldChangeAddressState_onFailingCoordinateSearch() {
        let coordinateSearchSpy = CoordinateSearchSpy(stub: .failure(anyError()))
        let scheduler = DispatchQueue.test
        let (sut, spy) = makeSUT(
            coordinateSearch: coordinateSearchSpy,
            scheduler: scheduler.eraseToAnyScheduler()
        )
        XCTAssertEqual(spy.values, [
            .state(region: .test, addressState: nil),
        ])
        
        sut.updateRegion(to: .any)
        scheduler.advance(by: .milliseconds(500))
        
        XCTAssertEqual(spy.values, [
            .state(region: .test, addressState: .none),
            .state(region: .any,  addressState: .none),
            .state(region: .any,  addressState: .searching),
            .state(region: .any,  addressState: .none)
        ])
    }
    
    func test_regionChange_shouldNotInvokeCoordinateSearch_beforeDebounceInterval() {
        let coordinateSearchSpy = CoordinateSearchSpy()
        let scheduler = DispatchQueue.test
        let (sut, _) = makeSUT(
            coordinateSearch: coordinateSearchSpy,
            scheduler: scheduler.eraseToAnyScheduler()
        )
        
        sut.updateRegion(to: .any)
        scheduler.advance(by: .milliseconds(499))
        XCTAssertEqual(coordinateSearchSpy.calls, [])
        
        scheduler.advance(by: .milliseconds(1))
        XCTAssertEqual(coordinateSearchSpy.calls, [.any])
    }
    
    func test_regionChange_shouldNotInvokeCoordinateSearchTwice_onSameRegion() {
        let coordinateSearchSpy = CoordinateSearchSpy()
        let scheduler = DispatchQueue.test
        let (sut, _) = makeSUT(
            coordinateSearch: coordinateSearchSpy,
            scheduler: scheduler.eraseToAnyScheduler()
        )
        
        sut.updateRegion(to: .any)
        scheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(coordinateSearchSpy.calls, [.any])
        
        sut.updateRegion(to: .any)
        scheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(coordinateSearchSpy.calls, [.any])
    }
    
    func test_regionChange_shouldNotInvokeCoordinateSearchTwice_onRegionWithSameCenter() {
        let coordinateSearchSpy = CoordinateSearchSpy()
        let scheduler = DispatchQueue.test
        let (sut, _) = makeSUT(
            coordinateSearch: coordinateSearchSpy,
            scheduler: scheduler.eraseToAnyScheduler()
        )
        XCTAssertEqual(coordinateSearchSpy.calls, [])
        
        sut.updateRegion(to: .another)
        scheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(coordinateSearchSpy.calls, [.test])
        
        sut.updateRegion(to: .test)
        scheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(coordinateSearchSpy.calls, [.test])
    }
    
    func test_regionChange_shouldChangeState_onDifferentRegionWithSameCenter() {
        let scheduler = DispatchQueue.test
        let (sut, spy) = makeSUT(
            scheduler: scheduler.eraseToAnyScheduler()
        )
        
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none, addressState: .none),
        ])
        
        sut.updateRegion(to: .another)
        scheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(spy.values, [
            .state(region: .test,        search: .none, addressState: .none),
            .state(region: .another, search: .none, addressState: .none),
            .state(region: .another, search: .none, addressState: .searching),
            .state(region: .another, search: .none, addressState: .address(.test)),
        ])
        
        sut.updateRegion(to: .test)
        scheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(spy.values, [
            .state(region: .test,        search: .none, addressState: .none),
            .state(region: .another, search: .none, addressState: .none),
            .state(region: .another, search: .none, addressState: .searching),
            .state(region: .another, search: .none, addressState: .address(.test)),
            .state(region: .test,        search: .none, addressState: .address(.test)),
        ], "Should change the state just for the region")
    }
    
    func test_regionChange_shouldChangeState_onDifferentRegionWithCloseCenter() {
        let scheduler = DispatchQueue.test
        let (sut, spy) = makeSUT(
            isClose: { _, _ in true },
            scheduler: scheduler.eraseToAnyScheduler()
        )
        
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none, addressState: .none)
        ])
        
        sut.updateRegion(to: .any)
        scheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none, addressState: .none),
            .state(region: .any,  search: .none, addressState: .none),
            .state(region: .any,  search: .none, addressState: .searching),
            .state(region: .any,  search: .none, addressState: .address(.test)),
        ])
        
        sut.updateRegion(to: .test)
        scheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none, addressState: .none),
            .state(region: .any,  search: .none, addressState: .none),
            .state(region: .any,  search: .none, addressState: .searching),
            .state(region: .any,  search: .none, addressState: .address(.test)),
            .state(region: .test, search: .none, addressState: .address(.test)),
        ], "Should change the state just for the region")
    }
    
    func test_regionChange_shouldChangeState_onRegionWithNonCloseCenter() {
        let scheduler = DispatchQueue.test
        let (sut, spy) = makeSUT(
            isClose: { _, _ in false },
            scheduler: scheduler.eraseToAnyScheduler()
        )
        
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none, addressState: .none),
        ])
        
        sut.updateRegion(to: .any)
        scheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none, addressState: .none),
            .state(region: .any,  search: .none, addressState: .none),
            .state(region: .any,  search: .none, addressState: .searching),
            .state(region: .any,  search: .none, addressState: .address(.test)),
        ])
        
        sut.updateRegion(to: .test)
        scheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(spy.values.count, 7)
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none, addressState: .none),
            .state(region: .any,  search: .none, addressState: .none),
            .state(region: .any,  search: .none, addressState: .searching),
            .state(region: .any,  search: .none, addressState: .address(.test)),
            .state(region: .test, search: .none, addressState: .address(.test)),
            .state(region: .test, search: .none, addressState: .searching),
            .state(region: .test, search: .none, addressState: .address(.test)),
        ], "Should change the state just for the region and address")
    }
    
#warning("how to test there is `receive(on:)` in the pipeline?")
    //    func test_regionChange_shouldChangeState_onMainThread() {
    //        let scheduler = DispatchQueue.test
    //        let (sut, spy) = makeSUT(
    //            scheduler: scheduler.eraseToAnyScheduler()
    //        )
    //
    //        XCTAssertEqual(spy.values, [
    //            .value(.init(region: .test, search: .none, addressState: .none))
    //        ])
    //
    //        sut.updateRegion(to: .any)
    //        scheduler.advance(by: .milliseconds(500))
    //
    //        XCTAssert(Thread.isMainThread)
    //        XCTFail("Unimplemented")
    //    }
    
    func test_shouldSetSearchState_onSearchActivation() {
        let (sut, spy) = makeSUT()
        XCTAssertEqual(spy.values, [
            .value(.init(region: .test)),
        ])
        
        sut.handleIsSearching(false)
        XCTAssertEqual(spy.values, [
            .state(region: .test),
        ], "Change from non-searching to non-searching should not change state")
        
        sut.handleIsSearching(true)
        XCTAssertEqual(spy.values, [
            .state(region: .test),
            .state(region: .test, search: .empty),
        ], "Change from non-search to search should change state")
        
        sut.handleIsSearching(false)
        XCTAssertEqual(spy.values, [
            .state(region: .test),
            .state(region: .test, search: .empty),
            .state(region: .test),
        ], "Change from search to non-search should change state")
    }
    
    func test_shouldSetSearchState_onSearchTextEditing() {
        let scheduler = DispatchQueue.test
        let (sut, spy) = makeSUT(scheduler: scheduler.eraseToAnyScheduler())
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
        ])
        
        typeAndAdvance("", sut: sut, by: .milliseconds(300), on: scheduler)
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
            .state(region: .test, search: .empty),
            .state(region: .test, search: .init(searchText: "", suggestions: .completions([.test, .another]))),
        ])
        
        typeAndAdvance("Lond", sut: sut, by: .milliseconds(300), on: scheduler)
        XCTAssertEqual(spy.values.count, 5)
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
            .state(region: .test, search: .empty),
            .state(region: .test, search: .init(searchText: "",     suggestions: .completions([.test, .another]))),
            .state(region: .test, search: .init(searchText: "Lond", suggestions: .none)),
            .state(region: .test, search: .init(searchText: "Lond", suggestions: .completions([.test, .another]))),
        ])
        
        typeAndAdvance("London", sut: sut, by: .milliseconds(300), on: scheduler)
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
            .state(region: .test, search: .empty),
            .state(region: .test, search: .init(searchText: "",       suggestions: .completions([.test, .another]))),
            .state(region: .test, search: .init(searchText: "Lond",   suggestions: .none)),
            .state(region: .test, search: .init(searchText: "Lond",   suggestions: .completions([.test, .another]))),
            .state(region: .test, search: .init(searchText: "London", suggestions: .none)),
            .state(region: .test, search: .init(searchText: "London", suggestions: .completions([.test, .another]))),
        ])
        
        typeAndAdvance("", sut: sut, by: .milliseconds(300), on: scheduler)
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
            .state(region: .test, search: .empty),
            .state(region: .test, search: .init(searchText: "",       suggestions: .completions([.test, .another]))),
            .state(region: .test, search: .init(searchText: "Lond",   suggestions: .none)),
            .state(region: .test, search: .init(searchText: "Lond",   suggestions: .completions([.test, .another]))),
            .state(region: .test, search: .init(searchText: "London", suggestions: .none)),
            .state(region: .test, search: .init(searchText: "London", suggestions: .completions([.test, .another]))),
            .state(region: .test, search: .empty),
            .state(region: .test, search: .init(searchText: "",       suggestions: .completions([.test, .another]))),
        ])
    }
    
    func test_searchTextEditing_shouldFilterDuplicates() {
        let scheduler = DispatchQueue.test
        let (sut, spy) = makeSUT(scheduler: scheduler.eraseToAnyScheduler())
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
        ])
        
        typeAndAdvance("Lon", sut: sut, by: .milliseconds(300), on: scheduler)
        typeAndAdvance("Lon", sut: sut, by: .milliseconds(300), on: scheduler)
        typeAndAdvance("Lon", sut: sut, by: .milliseconds(300), on: scheduler)
        
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
            .state(region: .test, search: .init(searchText: "Lon", suggestions: .none)),
            .state(region: .test, search: .init(searchText: "Lon", suggestions: .completions([.test, .another]))),
        ])
    }
    
    func test_dismissSearch_shouldNotChangeSearchState_onInactiveSearch() {
        let (sut, spy) = makeSUT()
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
        ])
        
        sut.dismissSearch()
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
        ], "Search dismiss should not change search state on inactive search.")
    }
    
    func test_dismissSearch_shouldSetSearchStateToNil_onActiveSearch() {
        let scheduler = DispatchQueue.test
        let (sut, spy) = makeSUT(scheduler: scheduler.eraseToAnyScheduler())
        
        typeAndAdvance("Lond", sut: sut, by: .milliseconds(300), on: scheduler)
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
            .state(region: .test, search: .init(searchText: "Lond", suggestions: .none)),
            .state(region: .test, search: .init(searchText: "Lond", suggestions: .completions([.test, .another]))),
        ])
        
        sut.dismissSearch()
        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
            .state(region: .test, search: .init(searchText: "Lond", suggestions: .none)),
            .state(region: .test, search: .init(searchText: "Lond", suggestions: .completions([.test, .another]))),
            .state(region: .test, search: .none),
        ])
    }
    
    func test_searchTextEditing_shouldInvokeSearchCompletion() {
        let searchCompleterSpy = SearchCompleterSpy()
        let scheduler = DispatchQueue.test
        let (sut, _) = makeSUT(
            searchCompleter: searchCompleterSpy,
            scheduler: scheduler.eraseToAnyScheduler()
        )
        XCTAssertEqual(searchCompleterSpy.calls, [])
        
        typeAndAdvance("Lond", sut: sut, by: .milliseconds(300), on: scheduler)
        
        XCTAssertEqual(searchCompleterSpy.calls, ["Lond"])
    }
    
    func test_searchTextEditing_shouldNotInvokeSearchCompletion_beforeDebounceInterval() {
        let searchCompleterSpy = SearchCompleterSpy()
        let scheduler = DispatchQueue.test
        let (sut, _) = makeSUT(
            searchCompleter: searchCompleterSpy,
            scheduler: scheduler.eraseToAnyScheduler()
        )
        XCTAssertEqual(searchCompleterSpy.calls, [])
        
        sut.setSearchText(to: "Lond")
        
        scheduler.advance(by: .milliseconds(299))
        XCTAssertEqual(searchCompleterSpy.calls, [])
        
        scheduler.advance(by: .milliseconds(1))
        XCTAssertEqual(searchCompleterSpy.calls, ["Lond"])
    }
    
    func test_suggestionsShouldBeEmpty_onEmptyCompletionsReturned() {
        let emptyCompleterSpy = SearchCompleterSpy(stub: .success([]))
        let scheduler = DispatchQueue.test
        let (sut, spy) = makeSUT(
            searchCompleter: emptyCompleterSpy,
            scheduler: scheduler.eraseToAnyScheduler()
        )
        
        typeAndAdvance("Lond", sut: sut, by: .milliseconds(300), on: scheduler)

        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .none)),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .completions([]))),
        ])
    }
    
    func test_suggestionsShouldBeEmpty_onFailingCompletionsLoad() {
        let failingCompleterSpy = SearchCompleterSpy(stub: .failure(anyError()))
        let scheduler = DispatchQueue.test
        let (sut, spy) = makeSUT(
            searchCompleter: failingCompleterSpy,
            scheduler: scheduler.eraseToAnyScheduler()
        )
        
        typeAndAdvance("Lond", sut: sut, by: .milliseconds(300), on: scheduler)

        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .none)),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .completions([]))),
        ])
    }
    
    func test_shouldDeliverSuggestions_onSuccessfulCompletionsLoad() {
        let successfulCompleterSpy = SearchCompleterSpy(stub: .test)
        let scheduler = DispatchQueue.test
        let (sut, spy) = makeSUT(
            searchCompleter: successfulCompleterSpy,
            scheduler: scheduler.eraseToAnyScheduler()
        )
        
        typeAndAdvance("Lond", sut: sut, by: .milliseconds(300), on: scheduler)

        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .none)),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .completions([.test, .another]))),
        ])
    }
    
    func test_completionSelection_shouldCallSearchAPI() {
        let searchSpy = LocalSearchSpy()
        let (sut, _) = makeSUT(localSearch: searchSpy)
        
        sut.completionButtonTapped(.another)
        
        XCTAssertEqual(searchSpy.calls, [.another])
    }
    
    func test_searchItemsShouldBeEmpty_onEmptyLocalSearch() {
        let emptyLocalSearchSpy = LocalSearchSpy(stub: .success([]))
        let scheduler = DispatchQueue.test
        let (sut, spy) = makeSUT(
            localSearch: emptyLocalSearchSpy,
            scheduler: scheduler.eraseToAnyScheduler()
        )
        
        typeAndAdvance("Lond", sut: sut, by: .milliseconds(300), on: scheduler)
        
        sut.completionButtonTapped(.another)
        scheduler.advance()

        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .none)),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .completions([.test, .another]))),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .searchItems([]))),
        ])
    }
    
    func test_searchItemsShouldBeEmpty_onFailingLocalSearchLoad() {
        let failingLocalSearchSpy = LocalSearchSpy(stub: .failure(anyError()))
        let scheduler = DispatchQueue.test
        let (sut, spy) = makeSUT(
            localSearch: failingLocalSearchSpy,
            scheduler: scheduler.eraseToAnyScheduler()
        )
        
        typeAndAdvance("Lond", sut: sut, by: .milliseconds(300), on: scheduler)
        
        sut.completionButtonTapped(.another)
        scheduler.advance()

        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .none)),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .completions([.test, .another]))),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .searchItems([]))),
        ])
    }
    
    func test_shouldDeliverSearchItems_onSuccessfulCompletionsLoad() {
        let successfulLocalSearchSpy = LocalSearchSpy(stub: .test)
        let scheduler = DispatchQueue.test
        let (sut, spy) = makeSUT(
            localSearch: successfulLocalSearchSpy,
            scheduler: scheduler.eraseToAnyScheduler()
        )
        
        typeAndAdvance("Lond", sut: sut, by: .milliseconds(300), on: scheduler)

        sut.completionButtonTapped(.another)
        scheduler.advance()

        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .none)),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .completions([.test, .another]))),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .searchItems([.test, .another]))),
        ])
    }
    
    func test_searchItemSelection_should_setRegion_resetSearch_setAddress() {
        let scheduler = DispatchQueue.test
        let (sut, spy) = makeSUT(scheduler: scheduler.eraseToAnyScheduler())
        
        typeAndAdvance("Lond", sut: sut, by: .milliseconds(300), on: scheduler)
        sut.completionButtonTapped(.another)
        scheduler.advance()
        sut.searchItemButtonTapped(.another)
        scheduler.advance()

        XCTAssertEqual(spy.values, [
            .state(region: .test, search: .none),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .none)),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .completions([.test, .another]))),
            .state(region: .test, search: .make(searchText: "Lond", suggestions: .searchItems([.test, .another]))),
            .state(region: .another, search: .none, addressState: .address(.another)),
        ])
    }

    func test_searchItemSelection_should_sendSearchDismiss() {
        let (sut, _) = makeSUT()
        let spy = ValueSpy(sut.dismissSearchSubject.map { _ in "dismiss" })
        
        sut.setSearchText(to: "Lond")
        sut.completionButtonTapped(.another)
        sut.searchItemButtonTapped(.another)
        
        XCTAssertEqual(spy.values, [.value("dismiss")])
    }

    // MARK: - Helpers
    
    private func makeSUT(
        initialRegion: CoordinateRegion = .test,
        coordinateSearch: CoordinateSearchSpy = .init(),
        searchCompleter: SearchCompleterSpy = .init(),
        localSearch: LocalSearchSpy = .init(),
        isClose: @escaping AddressMapSearchViewModel.IsClose = (==),
        scheduler: AnySchedulerOf<DispatchQueue> = .immediate,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: AddressMapSearchViewModel,
        spy: ValueSpy<AddressMapSearchState>
    ) {
        let sut = AddressMapSearchViewModel(
            initialRegion: initialRegion,
            coordinateSearch: coordinateSearch,
            isClose: isClose,
            searchCompleter: searchCompleter,
            localSearch: localSearch,
            scheduler: scheduler
        )
        let spy = ValueSpy(sut.$state)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(spy, file: file, line: line)
        trackForMemoryLeaks(coordinateSearch, file: file, line: line)
        trackForMemoryLeaks(searchCompleter, file: file, line: line)
        trackForMemoryLeaks(localSearch, file: file, line: line)

        return (sut, spy)
    }
    
    private final class CoordinateSearchSpy: CoordinateSearch {
        private(set) var calls = [LocationCoordinate2D]()
        private let stub: AddressResult
        
        init(stub: AddressResult = .test) {
            self.stub = stub
        }
        
        func search(for coordinate: LocationCoordinate2D) -> AddressResultPublisher {
            calls.append(coordinate)
            
            return Just(stub).eraseToAnyPublisher()
        }
    }
    
    private final class SearchCompleterSpy: SearchCompleter {
        private(set) var calls = [String]()
        private let stub: CompletionsResult
        
        init(stub: CompletionsResult = .test) {
            self.stub = stub
        }
        
        func complete(query: String) -> CompletionsResultPublisher {
            calls.append(query)
            
            return Just(stub).eraseToAnyPublisher()
        }
    }
    
    private final class LocalSearchSpy: LocalSearch {
        private(set) var calls = [Completion]()
        private let stub: SearchResult
        
        init(stub: SearchResult = .test) {
            self.stub = stub
        }
        
        func search(completion: Completion) -> SearchResultPublisher {
            calls.append(completion)
            
            return Just(stub).eraseToAnyPublisher()
        }
    }
    
    private func typeAndAdvance(
        _ text: String,
        sut: AddressMapSearchViewModel,
        by interval: DispatchQueue.SchedulerTimeType.Stride,
        on scheduler: TestSchedulerOf<DispatchQueue>
    ) {
        sut.setSearchText(to: text)
        scheduler.advance(by: interval)
    }
}

private final class ValueSpy<Value: Equatable> {
    private(set) var values = [Event]()
    private var cancellable: AnyCancellable?
    
    init<P>(_ publisher: P) where P: Publisher, P.Output == Value {
        cancellable = publisher.sink { [weak self] completion in
            switch completion {
            case .finished:
                self?.values.append(.finished)
                
            case .failure:
                self?.values.append(.failure)
            }
        } receiveValue: { [weak self] in
            self?.values.append(.value($0))
        }
    }
    
    enum Event: Equatable, CustomStringConvertible {
        case finished
        case failure
        case value(Value)
        
        var description: String {
            switch self {
            case .finished:
                return ".finished"
            case .failure:
                return ".failure"
            case let .value(value):
                return "\(value)"
            }
        }
    }
}

private extension ValueSpy<AddressMapSearchState>.Event {
    
    static func state(
        region: CoordinateRegion,
        search: AddressMapSearchState.Search? = nil,
        addressState: AddressMapSearchState.AddressState? = nil
    ) -> Self {
        .value(.init(region: region, search: search, addressState: addressState))
    }
}

func anyError() -> Error {
    NSError(domain: "any", code: 0)
}

private extension Address {
    
    static let test:    Self = .init()
    static let another: Self = .init()
}

private extension AddressResult {
    
    static let test:  Self = .success(.test)
    static let error: Self = .failure(anyError())
}

private extension Completion {
    
    static let test:    Self = .init()
    static let another: Self = .init()
}

private extension CompletionsResult {
    
    static let test:  Self = .success([.test, .another])
    static let empty: Self = .success([])
    static let error: Self = .failure(anyError())
}

private extension SearchItem {
    
    static let test:    Self = .init(address: .test, region: .test)
    static let another: Self = .init(address: .another, region: .another)
}

private extension SearchResult {
    
    static let test:  Self = .success([.test, .another])
    static let empty: Self = .success([])
    static let error: Self = .failure(anyError())
}

private extension CoordinateRegion {
    
    static let test:    Self = .init(center: .test, span: .test)
    static let another: Self = .init(center: .test, span: .any)
    static let any:     Self = .init(center: .any, span: .any)
}

private extension LocationCoordinate2D {
    
    static let test: Self = .init(latitude: 3, longitude: 4)
    static let any:  Self = .init(latitude: 30, longitude: 40)
}

private extension CoordinateSpan {
    
    static let test: Self = .init(latitudeDelta: 1, longitudeDelta: 2)
    static let any:  Self = .init(latitudeDelta: 10, longitudeDelta: 20)
}

extension CoordinateRegion: CustomStringConvertible {
    
    public var description: String {
        "Region(\(center.latitude.formatted()):\(center.longitude.formatted()) - \(span.latitudeDelta.formatted()):\(span.longitudeDelta.formatted()))"
    }
}

extension LocationCoordinate2D: CustomStringConvertible {
    
    public var description: String {
        "Coord(\(latitude.formatted()):\(longitude.formatted()))"
    }
}

extension CoordinateSpan: CustomStringConvertible {
    
    public var description: String {
        "Span(\(latitudeDelta.formatted()):\(longitudeDelta.formatted()))"
    }
}

extension AddressMapSearchState: CustomStringConvertible {
    
    var description: String {
        switch (region, search, addressState) {
        case (region, .none, .none):
            return "\n\(region)"
    
        case let (region, .some(search), .none):
            return "\n\(region) | \(search)"
    
        case let (region, .none, .some(addressState)):
            return "\n\(region) | \(addressState)"
    
        case let (region, .some(search), .some(addressState)):
            return "\n\(region) | \(search) | \(addressState)"
    
        default:
            return "\n\(region) | \(String(describing: search)) | \(String(describing: addressState))"
        }
    }
}

extension AddressMapSearchState.AddressState: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .searching:
            return "searching"
            
        case let .address(address):
            return "\(address)"
        }
    }
}

extension Optional where Wrapped == AddressMapSearchState.Search {
    
    static let empty:  Self = .make()
    
    static func make(
        searchText: String = "",
        suggestions: AddressMapSearchState.Suggestions? = nil
    ) -> Self {
        .some(.init(searchText: searchText, suggestions: suggestions))
    }
}

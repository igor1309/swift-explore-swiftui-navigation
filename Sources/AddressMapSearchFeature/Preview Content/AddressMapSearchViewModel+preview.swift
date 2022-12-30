//
//  AddressMapSearchViewModel+preview.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import Combine
import MapDomain

#if DEBUG
public extension AddressMapSearchViewModel {
    
    static let preview: AddressMapSearchViewModel = .init(
        initialRegion: .townLondon,
        coordinateSearch: CoordinateSearchStub(publisher: { .preview(coordinate: $0) }),
        isClose: { isClose($0, to: $1, withAccuracy: 0.0001) },
        searchCompleter: SearchCompleterStub(),
        localSearch: LocalSearchStub()
    )
    static let delayedPreview: AddressMapSearchViewModel = .init(
        initialRegion: .townLondon,
        coordinateSearch: CoordinateSearchStub(publisher: { .delayedPreview(coordinate: $0) }),
        isClose: { isClose($0, to: $1, withAccuracy: 0.0001) },
        searchCompleter: SearchCompleterStub(),
        localSearch: LocalSearchStub()
    )
    static let failing: AddressMapSearchViewModel = .init(
        initialRegion: .townLondon,
        coordinateSearch: CoordinateSearchStub(publisher: { .failing(coordinate: $0) }),
        isClose: { isClose($0, to: $1, withAccuracy: 0.0001) },
        searchCompleter: SearchCompleterStub(),
        localSearch: LocalSearchStub()
    )
}

private final class CoordinateSearchStub: CoordinateSearch {
    private let publisher: (LocationCoordinate2D) -> AddressResultPublisher
    
    init(publisher: @escaping (LocationCoordinate2D) -> AddressResultPublisher) {
        self.publisher = publisher
    }
    
    func search(for coordinate: LocationCoordinate2D) -> AddressResultPublisher {
        return publisher(coordinate)
    }
}

private extension CoordinateSearch.AddressResult {
    static let preview: Self = .success(.preview)
}

private final class SearchCompleterStub: SearchCompleter {
    private let emptyStub: SearchCompleter.CompletionsResult
    private let stub: SearchCompleter.CompletionsResult
    
    init(
        emptyStub: SearchCompleter.CompletionsResult = .success(.prevSearches),
        stub: SearchCompleter.CompletionsResult = .success(.preview)
    ) {
        self.emptyStub = emptyStub
        self.stub = stub
    }
    
    func complete(query: String) -> CompletionsResultPublisher {
        if query.isEmpty {
            return Just(emptyStub).eraseToAnyPublisher()
        } else {
            return Just(stub).eraseToAnyPublisher()
        }
    }
}

private extension SearchCompleter.CompletionsResult {
    static let preview: Self = .success(.preview)
}

private final class LocalSearchStub: LocalSearch {
    private let stub: LocalSearch.SearchResult
    
    init(stub: LocalSearch.SearchResult = .preview) {
        self.stub = stub
    }
    
    func search(completion: Completion) -> SearchResultPublisher {
        return Just(stub).eraseToAnyPublisher()
    }
}

private extension LocalSearch.SearchResult {
    static let preview: Self = .success([.preview, .another])
}

private extension SearchItem {

    static let preview: Self = .init(address: .preview, region: .cityLondon)
    static let another: Self = .init(address: .another, region: .cityMoscow)
}
#endif

//
//  LocalSearchCompleterTests.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

import AddressSearchService
import Combine
import MapKit
import XCTest

final class LocalSearchCompleterTests: XCTestCase {
    
    func test_init_shouldNotEmitCompletions() {
        let (sut, spy, delegate) = makeSUT()
        
        XCTAssertEqual(spy.values.count, 0)
        XCTAssertNotNil(sut)
        XCTAssertNotNil(delegate)
    }
    
    func test_queryShouldEmitCompletions() {
        let (sut, spy, delegate) = makeSUT()
        
        sut.search("Apple Store")
        _ = XCTWaiter().wait(for: [.init()], timeout: 0.5)
        
        XCTAssertEqual(spy.values.count, 1)
        XCTAssertEqual(delegate.completions.map(\.title), ["Apple Store", "Apple Store"])
        XCTAssertEqual(delegate.completions.map(\.subtitle), ["найти возле меня", "Bromyard, Англия"])
    }
    
    // MARK: - Helpers
    
    private typealias Spy = ValueSpy<[LocalSearchCompletion]>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: LocalSearchCompleter,
        spy: Spy,
        delegate: FakeDelegate
    ) {
        let delegate = FakeDelegate()
        let sut = LocalSearchCompleter(delegate: delegate)
        let spy = Spy(sut.completions())
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(spy, file: file, line: line)
        
        return (sut, spy, delegate)
    }
    
    private final class ValueSpy<Value: Equatable> {
        private(set) var values = [Event]()
        private var cancellable: AnyCancellable?
        
        init<P>(_ publisher: P) where P: Publisher, P.Output == Result<Value, Error>, P.Failure == Never {
            cancellable = publisher.sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.values.append(.finished)
                    
                case .failure:
                    self?.values.append(.failure)
                }
            } receiveValue: { [weak self] result in
                switch result {
                case .failure:
                    self?.values.append(.failure)
                    
                case let .success(value):
                    self?.values.append(.value(value))
                }
            }
        }
        
        enum Event: Equatable {
            case finished
            case failure
            case value(Value)
        }
    }
    
    private final class FakeDelegate: LocalSearchCompleterDelegate {
        private(set) var completions = [(title: String, subtitle: String)]()
        
        override func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            super.completerDidUpdateResults(completer)
            completions.append(contentsOf: completer.results.map { completion in
                (completion.title, completion.subtitle)
            })
        }
    }
}

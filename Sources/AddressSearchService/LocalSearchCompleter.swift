//
//  LocalSearchCompleter.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import Combine
import Foundation
import MapKit

public typealias CompletionsResult = Result<[LocalSearchCompletion], Error>
public typealias CompletionsPublisher = AnyPublisher<CompletionsResult, Never>

public final class LocalSearchCompleter {
    
    private let completer: MKLocalSearchCompleter
    private let delegate: LocalSearchCompleterDelegate
    private let subject: PassthroughSubject<CompletionsResult, Never>
    
    public init(delegate: LocalSearchCompleterDelegate = .init()) {
        self.completer = .init()
        self.delegate = delegate
        self.subject = .init()
        
        completer.delegate = delegate
        delegate.didUpdateResults = { [weak self] in
            self?.subject.send(.success($0))
        }
        delegate.didFailWithError = { [weak self] in
            self?.subject.send(.failure($0))
        }
    }
    
    public func search(_ query: String) {
        completer.queryFragment = query
    }
    
    public func completions() -> CompletionsPublisher {
        subject.eraseToAnyPublisher()
    }
}

open class LocalSearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    
    var didUpdateResults: (([LocalSearchCompletion]) -> Void)?
    var didFailWithError: ((Error) -> Void)?
    
    open func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        didUpdateResults?(completer.results.map(LocalSearchCompletion.init(rawValue:)))
    }
    
    public func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        didFailWithError?(error)
    }
}

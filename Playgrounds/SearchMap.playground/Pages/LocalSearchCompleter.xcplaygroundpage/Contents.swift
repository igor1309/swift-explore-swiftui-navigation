import Combine
import Contacts
import MapKit

typealias CompletionsResult = Result<[MKLocalSearchCompletion], Error>
typealias CompletionsPublisher = AnyPublisher<CompletionsResult, Never>

final class LocalSearchCompleter {
    
    private let completer: MKLocalSearchCompleter
    private let delegate: Delegate
    private let subject: PassthroughSubject<CompletionsResult, Never>
    
    init() {
        completer = .init()
        delegate = .init()
        subject = .init()
        
        completer.delegate = delegate
        delegate.didUpdateResults = { [weak self] in
            self?.subject.send(.success($0))
        }
        delegate.didFailWithError = { [weak self] in
            self?.subject.send(.failure($0))
        }
    }
    
    func search(_ query: String) {
        completer.queryFragment = query
    }
    
    func completions() -> CompletionsPublisher {
        subject.eraseToAnyPublisher()
    }
    
    private class Delegate: NSObject, MKLocalSearchCompleterDelegate {
        var didUpdateResults: (([MKLocalSearchCompletion]) -> Void)?
        var didFailWithError: ((Error) -> Void)?
        
        func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            didUpdateResults?(completer.results)
        }
        
        func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
            didFailWithError?(error)
        }
    }
}

let completer = LocalSearchCompleter()
let cancellable = completer.completions().sink {
    print($0)
} receiveValue: {
    switch $0 {
    case let .success(searchCompletions):
        searchCompletions.forEach {
            print($0.title, "/", $0.subtitle)
        }
        
    case let .failure(error):
        print(error.localizedDescription)
    }
}

//completer.region = CoordinateRegion.moscowCity.rawValue
completer.search("Apple Store")

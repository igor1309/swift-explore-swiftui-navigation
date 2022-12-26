import Combine
import Contacts
import MapKit
//import MapFeature

struct Address {
    let street: String
    let city: String
}

extension Address {
    
    init?(mapItem: MKMapItem) {
        guard let postalAddress = mapItem.placemark.postalAddress
        else {
            return nil
        }
        
        self.street = postalAddress.street
        self.city = postalAddress.city
    }
}

typealias CompletionResult = Result<[MKLocalSearchCompletion], Error>

class LocalSearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    var didUpdateResults: (([MKLocalSearchCompletion] ) -> Void)?
    var didFailWithError: ((Error) -> Void)?
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        didUpdateResults?(completer.results)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        didFailWithError?(error)
    }
}

struct LocalSearchCompleter {
    let search: (String) -> Void
    let completions: () -> AnyPublisher<CompletionResult, Never>
}

extension LocalSearchCompleter {
    #warning("NOT WORKING")
    static var live: Self {
        
        let completer = MKLocalSearchCompleter()
        let delegate = LocalSearchCompleterDelegate()
        let subject = PassthroughSubject<CompletionResult, Never>()
        
        completer.delegate = delegate
        delegate.didUpdateResults = { [subject] in
            subject.send(.success($0))
        }
        delegate.didFailWithError = { [subject] in
            subject.send(.failure($0))
        }
        
        return .init(
            search: { completer.queryFragment = $0 },
            completions: { subject.eraseToAnyPublisher() }
        )
    }
}

let completer = LocalSearchCompleter.live
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
completer.search("Apple Store")

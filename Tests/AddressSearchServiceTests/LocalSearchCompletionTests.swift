//
//  LocalSearchCompletionTests.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

@testable import AddressSearchService
import XCTest

final class LocalSearchCompletionTests: XCTestCase {
    
    func test_memberwiseInitLocalSearchCompletion_shouldSetRawValueToNil() {
        let sut = LocalSearchCompletion(
            title: "title",
            subtitle: "subtitle",
            titleHighlightRanges: [],
            subtitleHighlightRanges: []
        )
        
        XCTAssertNil(sut.rawValue)
    }
    
    func test_rawValueInitLocalSearchCompletion_shouldNotSetRawValueToNil() {
        let sut = LocalSearchCompletion(rawValue: .init())
        
        XCTAssertNotNil(sut.rawValue)
    }
}

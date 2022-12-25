//
//  SearchCompletionSnapshotTests.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

@testable import AddressSearchService
import SnapshotTesting
import XCTest

final class SearchCompletionSnapshotTests: XCTestCase {
    
    func test_snapshot() throws {
        let searchCompletion: LocalSearchCompletion = .test

        try assertAsImage(searchCompletion.highlightedTitle(.test))
        try assertAsImage(searchCompletion.highlightedSubtitle(.test))
    }
}

extension LocalSearchCompletion {
    
    static let test: Self = {
        let title = "TestTitle"
        let subtitle = "TestSubTitle"
        
        let titleRange0 = title.range(of: "Test")!
        let titleNSRange0 = NSRange(titleRange0, in: title)
        
        let titleRange1 = title.range(of: "itl")!
        let titleNSRange1 = NSRange(titleRange1, in: title)
        
        let subtitleRange = subtitle.range(of: "stSubTi")!
        let subtitleNSRange = NSRange(subtitleRange, in: title)
        
        return .init(
            title: "TestTitle",
            subtitle: "TestSubTitle",
            titleHighlightRanges: [titleNSRange0, titleNSRange1],
            subtitleHighlightRanges: [subtitleNSRange]
        )
    }()
}

extension AttributeContainer {
    
    static let test: Self = {
        var container: AttributeContainer = .init()
        container.foregroundColor = .blue
        container.underlineStyle = .single

        return container
    }()
}

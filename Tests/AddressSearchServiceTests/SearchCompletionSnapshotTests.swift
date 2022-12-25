//
//  SearchCompletionSnapshotTests.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

import SnapshotTesting
import XCTest

struct SearchCompletion {
    
    /// The title string associated with the point of interest.
    var title: String
    
    /// The subtitle (if any) associated with the point of interest.
    var subtitle: String
    
    /// The ranges of characters to highlight in the title string.
    var titleHighlightRanges: [NSRange]
    
    /// The ranges of characters to highlight in the subtitle string.
    var subtitleHighlightRanges: [NSRange]
}

extension SearchCompletion {
    
    func highlightedTitle(_ attributes: AttributeContainer) -> AttributedString {
        highlighted(
            string: title,
            attributes: attributes,
            ranges: titleHighlightRanges
        )
    }
    
    func highlightedSubtitle(_ attributes: AttributeContainer) -> AttributedString {
        highlighted(
            string: subtitle,
            attributes: attributes,
            ranges: subtitleHighlightRanges
        )
    }
    
    private func highlighted(
        string: String,
        attributes: AttributeContainer,
        ranges: [NSRange]
    ) -> AttributedString {
        var attributedString = AttributedString(string)
        
        let ranges: [Range<AttributedString.Index>] = ranges.compactMap {
            guard
                let range = Range<String.Index>($0, in: string),
                let attributedRange = attributedString.range(of: string[range])
            else {
                return nil
            }
            
            return attributedRange
        }
        
        for range in ranges {
            attributedString[range].setAttributes(attributes)
        }
        
        return attributedString
    }
}

extension SearchCompletion {
    
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

final class SearchCompletionSnapshotTests: XCTestCase {
    
    func test_snapshot() throws {
        let searchCompletion: SearchCompletion = .test

        try assertAsImage(searchCompletion.highlightedTitle(.test))
        try assertAsImage(searchCompletion.highlightedSubtitle(.test))
    }
}

//
//  SearchCompletionTests.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

import SnapshotTesting
import SwiftUI
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

/// [Episode #41: A Tour of Snapshot Testing](https://www.pointfree.co/collections/tours/snapshot-testing/ep41-a-tour-of-snapshot-testing)
final class SearchCompletionTests: XCTestCase {
    
    func test_snapshot() throws {
        let searchCompletion: SearchCompletion = .test
        let titleText = Text(searchCompletion.highlightedTitle(.test))
        let subtitleText = Text(searchCompletion.highlightedSubtitle(.test))
        let titleView = try XCTUnwrap(UIHostingController(rootView: titleText).view)
        let subtitleView = try XCTUnwrap(UIHostingController(rootView: subtitleText).view)
        
        assertSnapshot(matching: titleView, as: .image(size: titleView.intrinsicContentSize))
        assertSnapshot(matching: subtitleView, as: .image(size: subtitleView.intrinsicContentSize))
    }
}


extension Snapshotting where Value == AttributedString, Format == UIImage {
//
//    /// [Episode #41: A Tour of Snapshot Testing](https://www.pointfree.co/collections/tours/snapshot-testing/ep41-a-tour-of-snapshot-testing)
//    static let image: Snapshotting = Snapshotting<UIView, UIImage>.image.pullback { string in
//        let label = UILabel()
//        label.attributedText = NSAttributedString(string)
//        label.numberOfLines = 0
//        label.backgroundColor = .white
//        label.frame.size = label.systemLayoutSizeFitting(
//            CGSize(width: 300, height: 0),
//            withHorizontalFittingPriority: .defaultHigh,
//            verticalFittingPriority: .defaultLow
//        )
//
//        return label
//    }
}

extension Snapshotting where Value == NSAttributedString, Format == UIImage {

    /// [Episode #41: A Tour of Snapshot Testing](https://www.pointfree.co/collections/tours/snapshot-testing/ep41-a-tour-of-snapshot-testing)
    static let image: Snapshotting = Snapshotting<UIView, UIImage>.image.pullback { string in
        let label = UILabel()
        label.attributedText = string
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.frame.size = label.systemLayoutSizeFitting(
            CGSize(width: 300, height: 0),
            withHorizontalFittingPriority: .defaultHigh,
            verticalFittingPriority: .defaultLow
        )
        
        return label
    }
}

//
//  SearchCompletion.swift
//  
//
//  Created by Igor Malyarov on 25.12.2022.
//

import Foundation

public struct SearchCompletion {
    
    /// The title string associated with the point of interest.
    public var title: String
    
    /// The subtitle (if any) associated with the point of interest.
    public var subtitle: String
    
    /// The ranges of characters to highlight in the title string.
    public var titleHighlightRanges: [NSRange]
    
    /// The ranges of characters to highlight in the subtitle string.
    public var subtitleHighlightRanges: [NSRange]
    
    public init(
        title: String,
        subtitle: String,
        titleHighlightRanges: [NSRange],
        subtitleHighlightRanges: [NSRange]
    ) {
        self.title = title
        self.subtitle = subtitle
        self.titleHighlightRanges = titleHighlightRanges
        self.subtitleHighlightRanges = subtitleHighlightRanges
    }
}

extension SearchCompletion {
    
    public func highlightedTitle(_ attributes: AttributeContainer) -> AttributedString {
        highlighted(
            string: title,
            attributes: attributes,
            ranges: titleHighlightRanges
        )
    }
    
    public func highlightedSubtitle(_ attributes: AttributeContainer) -> AttributedString {
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

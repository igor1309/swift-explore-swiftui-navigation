//
//  Completion+ext.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import Foundation

#if DEBUG
public extension Completion {
    
    static let preview: Self = {
        let title = "Suggestion Title"
        let subtitle = "Slightly longer Suggestion Subtitle"
        
        let titleRange0 = title.range(of: "Sugg")!
        let titleNSRange0 = NSRange(titleRange0, in: title)
        
        let titleRange1 = title.range(of: "ion Ti")!
        let titleNSRange1 = NSRange(titleRange1, in: title)
        
        let subtitleRange = subtitle.range(of: "onger Sug")!
        let subtitleNSRange = NSRange(subtitleRange, in: subtitle)
        
        return .init(
            title: title,
            subtitle: subtitle,
            titleHighlightRanges: [titleNSRange0, titleNSRange1],
            subtitleHighlightRanges: [subtitleNSRange]
        )
    }()
    
    static let fake1: Self = .init(
        title: "Simple Fake 1",
        subtitle: "Without highlight ranges",
        titleHighlightRanges: [],
        subtitleHighlightRanges: []
    )
    static let fake2: Self = .init(
        title: "Simple Fake 2",
        subtitle: "Without highlight ranges",
        titleHighlightRanges: [],
        subtitleHighlightRanges: []
    )
}
#endif

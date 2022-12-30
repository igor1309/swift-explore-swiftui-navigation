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
    
    static let prevSearch1: Self = {
        let title = "Prev Search 1"
        let titleRange = title.range(of: "arch 1")!
        let titleNSRange = NSRange(titleRange, in: title)
        
        return .init(
            title: title,
            subtitle: "Subtitle without highlight ranges",
            titleHighlightRanges: [titleNSRange],
            subtitleHighlightRanges: []
        )
    }()
    static let prevSearch2: Self = {
        let title = "Prev Search 2"
        let titleRange = title.range(of: "arch 2")!
        let titleNSRange = NSRange(titleRange, in: title)
        
        return .init(
            title: title,
            subtitle: "Subtitle without highlight ranges",
            titleHighlightRanges: [titleNSRange],
            subtitleHighlightRanges: []
        )
    }()
    static let prevSearch3: Self = {
        let title = "Prev Search 3"
        let titleRange = title.range(of: "arch 3")!
        let titleNSRange = NSRange(titleRange, in: title)
        
        return .init(
            title: title,
            subtitle: "Subtitle without highlight ranges",
            titleHighlightRanges: [titleNSRange],
            subtitleHighlightRanges: []
        )
    }()
    static let fake1: Self = {
        let title = "Simple Fake 1"
        let titleRange = title.range(of: "le Fa")!
        let titleNSRange = NSRange(titleRange, in: title)
        
        return .init(
            title: title,
            subtitle: "Subtitle without highlight ranges",
            titleHighlightRanges: [titleNSRange],
            subtitleHighlightRanges: []
        )
    }()
    static let fake2: Self = {
        let title = "Simple Fake 2"
        let titleRange = title.range(of: "le Fa")!
        let titleNSRange = NSRange(titleRange, in: title)
        
        return .init(
            title: title,
            subtitle: "Subtitle without highlight ranges",
            titleHighlightRanges: [titleNSRange],
            subtitleHighlightRanges: []
        )
    }()
}
#endif

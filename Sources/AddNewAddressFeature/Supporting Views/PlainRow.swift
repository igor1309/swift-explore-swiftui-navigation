//
//  PlainRow.swift
//  
//
//  Created by Igor Malyarov on 27.12.2022.
//

import SwiftUI

struct PlainRow: View {
    
    private let title: AttributedString
    private let subtitle: AttributedString
    
    init(title: AttributedString, subtitle: AttributedString) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            
            Text(subtitle)
                .font(.footnote)
        }
        .foregroundColor(.secondary)
    }
}

extension PlainRow {
    
    init(_ completion: Completion, attributes: AttributeContainer) {
        self.init(
            title: completion.highlightedTitle(attributes),
            subtitle: completion.highlightedSubtitle(attributes)
        )
    }
    
    init(address: Address) {
        self.init(
            title: address.street.rawValue,
            subtitle: address.city.rawValue
        )
    }
    
    init(title: String, subtitle: String) {
        self.title = .init(title, attributes: .primary)
        self.subtitle = .init(subtitle)
    }
}

struct PlainRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PlainRow(.preview, attributes: .primary)
            PlainRow(address: .preview)
            PlainRow(title: "A Title", subtitle: "A longer Subtitle")
        }
        .listStyle(.plain)
        .preferredColorScheme(.dark)
    }
}

//
//  CompletionView.swift
//  
//
//  Created by Igor Malyarov on 26.12.2022.
//

import SwiftUI

struct CompletionView: View {
    
    private let completion: Completion
    private let attributes: AttributeContainer
    
    init(_ completion: Completion, attributes: AttributeContainer) {
        self.completion = completion
        self.attributes = attributes
    }
    
    var body: some View {
        PlainRow(completion, attributes: attributes)
            .foregroundColor(.secondary)
    }
}

struct CompletionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            List {
                CompletionView(.preview, attributes: .primary)
                CompletionView(.preview, attributes: .underlined)
                CompletionView(.preview, attributes: .mint)
                CompletionView(.preview, attributes: .red)
                CompletionView(.preview, attributes: .underlinedRed)
            }
            .listStyle(.plain)
        }
        .preferredColorScheme(.dark)
    }
}

//
//  DismissSearchView.swift
//  
//
//  Created by Igor Malyarov on 28.12.2022.
//

import Combine
import SwiftUI

struct DismissSearchView: View {
    @Environment(\.dismissSearch) private var dismissSearch

    let dismiss: PassthroughSubject<Void, Never>

    var body: some View {
        EmptyView()
            .onReceive(dismiss) { _ in dismissSearch() }
    }
}

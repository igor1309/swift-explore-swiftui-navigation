//
//  ContentView.swift
//  DismissSearchPreviewApp
//
//  Created by Igor Malyarov on 24.12.2022.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch

    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Parent: \(isSearching ? "is searching" : "not searching")")
                .foregroundColor(isSearching ? .primary : .secondary)
            
            Button("Parent: Dismiss Search not working") {
                dismissSearch()
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            
            Child()
        }
        .searchable(text: $searchText)
    }
}

struct Child: View {

    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch

    var body: some View {
        VStack(spacing: 32) {
            Text("Child: \(isSearching ? "is searching" : "not searching")")
                .foregroundColor(isSearching ? .primary : .secondary)
            
            Button("Child: Dismiss Search is working") {
                dismissSearch()
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .disabled(!isSearching)
        }
        .padding()
        .background(.thinMaterial)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView()
        }
        .preferredColorScheme(.dark)
    }
}

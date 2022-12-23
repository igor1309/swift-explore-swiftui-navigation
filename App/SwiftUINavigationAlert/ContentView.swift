//
//  ContentView.swift
//  SwiftUINavigationAlert
//
//  Created by Igor Malyarov on 23.12.2022.
//

import SwiftUI
import SwiftUINavigation

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        NavigationStack {
            Button(role: .destructive, action: viewModel.deleteButtonTapped) {
                Text("Delete")
            }
            .alert(
                unwrapping: $viewModel.alert,
                action: viewModel.alertButtonTapped
            )
//            .alert
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(viewModel: .init())
            // ContentView(viewModel: .init(route: .alert(.)))
        }
        .preferredColorScheme(.dark)
    }
}

final class ContentViewModel: ObservableObject {
    
    @Published var route: Route?
    
    @Published var alert: AlertState<AlertAction>?
    
    init(route: Route? = nil) {
        self.route = route
    }
    
    func deleteButtonTapped() {
        self.alert = .init(
            title: { .init("Delete?") },
            actions: {
                .cancel(.init("Cancel"))
            },
            message: { .init("message") }
        )
    }
    
    func alertButtonTapped(action: AlertAction) {
        
    }
    
    enum Route {
        case alert(AlertState<AlertAction>)
    }
    
    enum AlertAction {
        case confirmDelete
    }
}

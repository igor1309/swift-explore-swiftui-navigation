//
//  ProfileView.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI
import SwiftUINavigation

public struct ProfileView: View {
    
    @ObservedObject private var viewModel: ProfileViewModel
    
    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("Profile View for \(String(describing: viewModel.profile))")
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                TBD("Order History")
                TBD("FAQ")
                TBD("About")
                TBD("Chat | Call us")
            }
            .padding()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: toolbar)
        .navigationDestination(unwrapping: $viewModel.route) { route in
            switch route.wrappedValue {
            case .editProfile:
                Text("TBD: Edit profile")
                
            case .orderHistory:
                Text("TBD: Order History")
                
            case .faq:
                Text("TBD: FAQ")
                
            case .cards:
                Text("TBD: Your Cards")
            }
        }
    }
    
    @ToolbarContentBuilder
    private func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .primaryAction, content: editProfileButton)
    }
    
    private func editProfileButton() -> some View {
        Button(action: viewModel.editProfileButtonTapped) {
            Label("Edit profile", systemImage: "pencil.line")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    private typealias Route = ProfileViewModel.Route

    private static func profileView(route: Route? = nil) -> some View {
        NavigationStack {
            ProfileView(
                viewModel: .init(
                    profile: .preview,
                    route: route
                )
            )
        }
    }
    
    static var previews: some View {
        Group {
            profileView()
            profileView(route: .editProfile)
            profileView(route: .orderHistory)
            profileView(route: .faq)
            profileView(route: .cards)
        }
        .preferredColorScheme(.dark)
    }
}

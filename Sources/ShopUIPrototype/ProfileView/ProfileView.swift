//
//  ProfileView.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI
import SwiftUINavigation

public struct ProfileView<
    ProfileEditor: View,
    OrderHistoryView: View,
    FaqView: View,
    CardsView: View
>: View {
    
    @ObservedObject private var viewModel: ProfileViewModel
    
    private let profileEditor: (Profile) -> ProfileEditor
    private let orderHistoryView: () -> OrderHistoryView
    private let faqView: () -> FaqView
    private let cardsView: () -> CardsView
    
    public init(
        viewModel: ProfileViewModel,
        profileEditor: @escaping (Profile) -> ProfileEditor,
        orderHistoryView: @escaping () -> OrderHistoryView,
        faqView: @escaping () -> FaqView,
        cardsView: @escaping () -> CardsView
    ) {
        self.viewModel = viewModel
        self.profileEditor = profileEditor
        self.orderHistoryView = orderHistoryView
        self.faqView = faqView
        self.cardsView = cardsView
    }
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                VStack(spacing: 9) {
                    Text(viewModel.profile.name)
                        .font(.title3.bold())
                    
                    Group {
                        Text(viewModel.profile.email.rawValue)
                        Text(viewModel.profile.phone.rawValue)
                    }
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                }
                
                Divider()
                
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
        .navigationDestination(
            unwrapping: .init(
                get: { viewModel.route },
                set: { viewModel.navigate(to: $0) }
            )
        ) { route in
            switch route.wrappedValue {
            case .editProfile:
                profileEditor(viewModel.profile)
                
            case .orderHistory:
                orderHistoryView()
                
            case .faq:
                faqView()
                
            case .cards:
                cardsView()
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
                ),
                profileEditor: { profile in
                    Text("TBD: Edit profile \(profile.id.rawValue.uuidString)")
                },
                orderHistoryView: {
                    Text("TBD: Order History")
                },
                faqView: {
                    Text("TBD: FAQ")
                },
                cardsView: {
                    Text("TBD: Your Cards")
                }
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

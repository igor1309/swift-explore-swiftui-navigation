//
//  ProfileView.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Domain
import SwiftUI
import SwiftUINavigation

public struct ProfileView<
    ProfileEditor: View,
    OrderHistoryView: View,
    FaqView: View,
    CardsView: View,
    ChatView: View,
    CallUsView: View
        
>: View {
    
    @ObservedObject private var viewModel: ProfileViewModel
    
    private let profileEditor: (Profile) -> ProfileEditor
    private let orderHistoryView: () -> OrderHistoryView
    private let faqView: () -> FaqView
    private let cardsView: () -> CardsView
    private let chatView: () -> ChatView
    private let callUsView: () -> CallUsView
    
    public init(
        viewModel: ProfileViewModel,
        profileEditor: @escaping (Profile) -> ProfileEditor,
        orderHistoryView: @escaping () -> OrderHistoryView,
        faqView: @escaping () -> FaqView,
        cardsView: @escaping () -> CardsView,
        chatView: @escaping () -> ChatView,
        callUsView: @escaping () -> CallUsView
    ) {
        self.viewModel = viewModel
        self.profileEditor = profileEditor
        self.orderHistoryView = orderHistoryView
        self.faqView = faqView
        self.cardsView = cardsView
        self.chatView = chatView
        self.callUsView = callUsView
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
                
                buttons()
                    .padding(.top)
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
                
            case .chat:
                chatView()
                
            case .callUs:
                callUsView()
            }
        }
    }
    
    @ViewBuilder
    private func buttons() -> some View {
        VStack(spacing: 32) {
            Group {
                orderHistoryButton()
                cardsButton()
                faqButton()
                aboutButton()
                
                HStack(alignment: .firstTextBaseline) {
                    chatButton()
                        .frame(maxWidth: .infinity)
                    
                    callUsButton()
                        .frame(maxWidth: .infinity)
                }
                .buttonBorderShape(.capsule)
            }
            .buttonStyle(.bordered)
            
            logoutButton()
                .buttonStyle(.borderless)
                .controlSize(.mini)
                .padding(.top)
        }
    }
    
    private func orderHistoryButton() -> some View {
        Button(action: viewModel.orderHistoryButtonTapped) {
            Label {
                Text("ORDER_HISTORY_BUTTON_TITLE", bundle: .module)
            } icon: {
                Image(systemName: "list.dash")
            }
        }
        
    }
    private func cardsButton() -> some View {
        Button(action: viewModel.cardsButtonTapped) {
            Label {
                Text("CARDS_BUTTON_TITLE", bundle: .module)
            } icon: {
                Image(systemName: "creditcard")
            }
        }
        
    }
    private func faqButton() -> some View {
        Button(action: viewModel.faqButtonTapped) {
            Label {
                Text("FAQ_BUTTON_TITLE", bundle: .module)
            } icon: {
                Image(systemName: "questionmark.diamond")
            }
        }
        
    }
    private func aboutButton() -> some View {
        Button(action: viewModel.aboutButtonTapped) {
            Label {
                Text("ABOUT_BUTTON_TITLE", bundle: .module)
            } icon: {
                Image(systemName: "rectangle.and.text.magnifyingglass")
            }
        }
        
    }
    private func chatButton() -> some View {
        Button(action: viewModel.chatButtonTapped) {
            Label {
                Text("CHAT_BUTTON_TITLE", bundle: .module)
            } icon: {
                Image(systemName: "bubble.left.and.bubble.right")
            }
        }
        
    }
    private func callUsButton() -> some View {
        Button(action: viewModel.callUsButtonTapped) {
            Label {
                Text("CALL_US_BUTTON_TITLE", bundle: .module)
            } icon: {
                Image(systemName: "phone")
            }
        }
    }
    private func logoutButton() -> some View {
        Button(role: .destructive, action: viewModel.logoutButtonTapped) {
            Label {
                Text("LOGOUT_BUTTON_TITLE", bundle: .module)
            } icon: {
                Image(systemName: "figure.run.circle")
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
                },
                chatView: {
                    Text("TBD: Chat")
                },
                callUsView: {
                    Text("TBD: Call Us")
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

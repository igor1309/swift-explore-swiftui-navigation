//
//  ProfileViewModel.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Domain
import Foundation
import SwiftUINavigation

public final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var route: Route?
    
    let profile: Profile
    
    private let logout: () -> Void
    
    public init(
        profile: Profile,
        route: Route? = nil,
        logout: @escaping () -> Void
    ) {
        self.profile = profile
        self.route = route
        self.logout = logout
    }
    
    public func navigate(to route: Route?) {
        self.route = route
    }
    
    public func navigate(to navigation: Route.Navigation) {
        self.route = .navigation(navigation)
    }
    
    public func navigate(to alert: AlertState<AlertAction>) {
        self.route = .alert(alert)
    }
    
    func editProfileButtonTapped() {
        navigate(to: .editProfile)
    }
    
    func orderHistoryButtonTapped() {
        navigate(to: .orderHistory)
    }
    
    func cardsButtonTapped() {
        navigate(to: .cards)
    }
    
    func faqButtonTapped() {
        navigate(to: .faq)
    }
    
    func aboutButtonTapped() {
        navigate(to: .cards)
    }
    
    func chatButtonTapped() {
        navigate(to: .chat)
    }
    
    func callUsButtonTapped() {
        navigate(to: .callUs)
    }
    
    func logoutButtonTapped() {
        navigate(to: .logout)
    }
    
    func alertButtonTapped(_ action: AlertAction) {
        switch action {
        case .confirmLogoutButtonTapped:
            confirmLogoutButtonTapped()
        }
    }
    
    func confirmLogoutButtonTapped() {
        logout()
    }
    
    public enum Route: Hashable, Identifiable {
        case navigation(Navigation)
        case alert(AlertState<AlertAction>)
        
        public enum Navigation: Hashable, Identifiable {
            case editProfile
            case orderHistory
            case faq
            case cards
            case chat
            case callUs
            
            public var id: Self { self }
        }
        
        public enum Alert: Hashable, Identifiable {
            case logout
            
            public var id: Self { self }
        }

        public var id: Self { self }
    }
    
    public enum AlertAction: Hashable {
        case confirmLogoutButtonTapped
    }
}

extension AlertState<ProfileViewModel.AlertAction> {
    
    static let logout: Self = .init {
        TextState("CONFIRM_LOGOUT_TITLE", bundle: .module)
    } actions: {
        ButtonState(
            role: .destructive,
            action: .confirmLogoutButtonTapped
        ) {
            TextState("CONFIRM_LOGOUT", bundle: .module)
        }
    }
}

extension ProfileViewModel: Hashable {
    
    public static func == (lhs: ProfileViewModel, rhs: ProfileViewModel) -> Bool {
        lhs === rhs
    }
    
    public func hash (into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

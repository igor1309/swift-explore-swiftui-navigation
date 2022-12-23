//
//  ProfileViewModel.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Domain
import Foundation

public final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var route: Route?
    
    let profile: Profile
    
    public init(
        profile: Profile,
        route: Route? = nil
    ) {
        self.profile = profile
        self.route = route
    }
    
    public func navigate(to route: Route?) {
        self.route = route
    }
    
    func editProfileButtonTapped() {
        navigate(to: .editProfile)
    }
    
    private func resetRoute() {
        route = nil
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
        #warning("???")
    }
    
    public enum Route: Hashable, Identifiable {
        case editProfile
        case orderHistory
        case faq
        case cards
        case chat
        case callUs
        
        public var id: Self { self }
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


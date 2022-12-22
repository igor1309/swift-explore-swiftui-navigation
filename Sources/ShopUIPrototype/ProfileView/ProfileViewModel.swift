//
//  ProfileViewModel.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

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
    
    public enum Route: Hashable, Identifiable {
        case editProfile
        case orderHistory
        case faq
        case cards
        
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


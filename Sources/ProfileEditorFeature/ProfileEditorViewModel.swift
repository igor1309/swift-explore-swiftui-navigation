//
//  ProfileEditorViewModel.swift
//  
//
//  Created by Igor Malyarov on 23.12.2022.
//

import Domain
import Foundation
import SwiftUINavigation

public final class ProfileEditorViewModel: ObservableObject {
    
    #warning("private(set)")
    @Published var route: Route?
    @Published var user: User
    
    private let saveProfile: (User) -> Void
    private let deleteAccount: () -> Void
    
    public init(
        user: User,
        route: Route? = nil,
        saveProfile: @escaping (User) -> Void,
        deleteAccount: @escaping () -> Void
    ) {
        self.user = user
        self.route = route
        self.saveProfile = saveProfile
        self.deleteAccount = deleteAccount
    }
    
    func navigate(to route: Route?) {
        self.route = route
    }
    
    func navigate(to alert: AlertState<AlertAction>) {
        navigate(to: .alert(alert))
    }
    
    func deleteAccountButtonTapped() {
        navigate(to: .confirmDelete)
    }
    
    func saveProfileButtonTapped() {
        
    }
    
    func alertButtonTapped(action: AlertAction) {
        switch action {
        case .confirmDeleteButtonTapped:
            self.deleteAccount()
        }
    }
    
    public enum Route: Hashable, Identifiable {
        case alert(AlertState<AlertAction>)
        
        public var id: Self { self }
    }
    
    public enum AlertAction {
        case confirmDeleteButtonTapped
    }
    
    public struct User {
        public var name: String
        public var email: Email
        public var phone: Phone
        
        public init(
            name: String,
            email: Email,
            phone: Phone
        ) {
            self.name = name
            self.email = email
            self.phone = phone
        }
    }
}

extension AlertState<ProfileEditorViewModel.AlertAction> {
    
    static let confirmDelete: Self = .init {
        .init("DELETE?", bundle: .module)
    } actions: {
        ButtonState(
            role: .destructive,
            action: .confirmDeleteButtonTapped,
            label: { .init("???", bundle: .module) }
        )
    } message: {
        .init("CONFIRM_DELETE", bundle: .module)
    }
}

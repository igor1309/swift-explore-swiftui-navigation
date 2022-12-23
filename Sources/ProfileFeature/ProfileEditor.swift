//
//  ProfileEditor.swift
//  
//
//  Created by Igor Malyarov on 22.12.2022.
//

import Domain
import SwiftUI
import Tagged

public struct ProfileEditor: View {
    
    @State private var user: User
    
    private let saveProfile: (User) -> Void
    private let deleteAccount: () -> Void
    
    public init(
        user: User,
        saveProfile: @escaping (User) -> Void,
        deleteAccount: @escaping () -> Void
    ) {
        self._user = State(initialValue: user)
        self.saveProfile = saveProfile
        self.deleteAccount = deleteAccount
    }
    
    public var body: some View {
        VStack {
            List {
                Section("NAME") {
                    TextField("NAME", text: $user.name)
                }
                
                Section("Email") {
                    TextField("Email", text: $user.email.rawValue)
                }
                
                Section {
                    TextField("PHONE", text: $user.phone.rawValue)
                } header: {
                    Text("PHONE")
                } footer: {
                    Button(role: .destructive, action: deleteAccount) {
                        Label {
                            Text("DELETE_ACCOUNT_BUTTON_TITLE", bundle: .module)
                        } icon: {
                            Image(systemName: "trash")
                        }
                    }
                    .font(.caption)
                    .padding(.top)
                    .frame(maxWidth: .infinity)
                }
            }
            
            Spacer(minLength: 100)
            
            Button {
                saveProfile(user)
            } label: {
                Label {
                    Text("SAVE_PROFILE_CHANGES", bundle: .module)
                        .padding(.vertical, 3)
                } icon: {
                    Image(systemName: "square.and.arrow.down")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding([.bottom, .horizontal])
        }
        .navigationTitle(Text("EDIT_PROFILE_NAVIGATION_TITLE", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
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

struct ProfileEditor_Previews: PreviewProvider {
    
    private typealias User = ProfileEditor.User
    
    @State static private var user = User(name: "", email: "", phone: "")
    
    static var previews: some View {
        NavigationStack {
            ProfileEditor(
                user: user,
                saveProfile: { _ in },
                deleteAccount: {}
            )
        }
        .preferredColorScheme(.dark)
    }
}

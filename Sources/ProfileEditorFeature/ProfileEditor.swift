//
//  ProfileEditor.swift
//  
//
//  Created by Igor Malyarov on 22.12.2022.
//

import Domain
import SwiftUI
import SwiftUINavigation
import Tagged

public struct ProfileEditor: View {
    
    @ObservedObject private var viewModel: ProfileEditorViewModel
    
    public init(viewModel: ProfileEditorViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            List {
                Section("NAME") {
                    TextField("NAME", text: $viewModel.user.name)
                }
                
                Section("Email") {
                    TextField("Email", text: $viewModel.user.email.rawValue)
                }
                
                Section {
                    TextField("PHONE", text: $viewModel.user.phone.rawValue)
                } header: {
                    Text("PHONE")
                } footer: {
                    deleteAccountButton()
                        .controlSize(.mini)
                        .padding(.top)
                        .frame(maxWidth: .infinity)
                }
            }
            
            Spacer(minLength: 100)
            
            saveProfileButton()
                .buttonStyle(.borderedProminent)
                .padding([.bottom, .horizontal])
        }
        .navigationTitle(Text("EDIT_PROFILE_NAVIGATION_TITLE", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            unwrapping: $viewModel.route,
            case: /ProfileEditorViewModel.Route.alert,
            action: viewModel.alertButtonTapped
        )
    }
    
    private func deleteAccountButton() -> some View {
        Button(
            role: .destructive,
            action: viewModel.deleteAccountButtonTapped
        ) {
            Label {
                Text("DELETE_ACCOUNT_BUTTON_TITLE", bundle: .module)
            } icon: {
                Image(systemName: "trash")
            }
        }
    }
    
    private func saveProfileButton() -> some View {
        Button(action: viewModel.saveProfileButtonTapped) {
            Label {
                Text("SAVE_PROFILE_CHANGES", bundle: .module)
                    .padding(.vertical, 3)
            } icon: {
                Image(systemName: "square.and.arrow.down")
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    
    struct Demo: View {
        
        var route: ProfileEditorViewModel.Route? = nil
        
        private typealias User = ProfileEditorViewModel.User
        
        @State private var user = User(name: "", email: "", phone: "")
        
        var body: some View {
            NavigationStack {
                ProfileEditor(
                    viewModel: .init(
                        user: user,
                        saveProfile: { _ in },
                        deleteAccount: {}
                    )
                )
            }
            .preferredColorScheme(.dark)
        }
    }
    
    static var previews: some View {
        Group {
            Demo()
            Demo(route: .alert(.confirmDelete))
        }
        .preferredColorScheme(.dark)
    }
}

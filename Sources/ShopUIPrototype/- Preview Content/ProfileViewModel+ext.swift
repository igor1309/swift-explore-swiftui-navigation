//
//  ProfileViewModel+ext.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

#if DEBUG
public extension ProfileViewModel {
    static let preview = ProfileViewModel(profile: .preview)
}
#endif

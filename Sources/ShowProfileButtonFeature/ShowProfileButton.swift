//
//  ShowProfileButton.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Domain
import SwiftUI

public struct ShowProfileButton: View {
    
    let profile: Profile
    let action: () -> Void
    
    public init(
        profile: Profile,
        action: @escaping () -> Void
    ) {
        self.profile = profile
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Label("Shop Grid View", systemImage: "person.circle")
        }
    }
}

struct ShowProfileButton_Previews: PreviewProvider {
    static var previews: some View {
        ShowProfileButton(profile: .preview, action: {})
    }
}

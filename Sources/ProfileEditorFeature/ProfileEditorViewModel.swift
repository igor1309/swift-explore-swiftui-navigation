//
//  ProfileEditorViewModel.swift
//  
//
//  Created by Igor Malyarov on 23.12.2022.
//

import Foundation

public final class ProfileEditorViewModel: ObservableObject {
    
    @Published private(set) var route: Route?
    
    public init(route: Route?) {
        self.route = route
    }
    
    public enum Route: Hashable, Identifiable {
        case deleteAccount
        
        public var id: Self { self }
    }
}

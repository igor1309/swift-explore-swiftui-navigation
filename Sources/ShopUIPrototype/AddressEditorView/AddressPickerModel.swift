//
//  AddressPickerModel.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation

public final class AddressPickerModel: ObservableObject {

    @Published var route: Route?
    
    public init(route: Route? = nil) {
        self.route = route
    }
    
    public enum Route: Identifiable {
        case newAddress
        
        public var id: Self { self }
    }
}

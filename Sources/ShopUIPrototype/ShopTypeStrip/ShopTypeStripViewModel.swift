//
//  ShopTypeStripViewModel.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation

public final class ShopTypeStripViewModel: ObservableObject {
    
    @Published var route: Route?
    
    let shopTypes: ShopTypes
    
    public init(shopTypes: ShopTypes, route: Route? = nil) {
        self.shopTypes = shopTypes
        self.route = route
    }
    
    func navigate(to shopType: ShopType) {
        route = .shopType(shopType)
    }
    
    public enum Route: Hashable, Identifiable {
        case shopType(ShopType)
        
        public var id: Self { self }
    }
}

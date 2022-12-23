//
//  ShopGridViewModel.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Domain
import Foundation

public final class ShopGridViewModel: ObservableObject {
    
    @Published private(set) var route: Route?

    let shops: Shops
    
    public init(shops: Shops, route: Route? = nil) {
        self.shops = shops
        self.route = route
    }
    
    public func navigate(to route: Route?) {
        self.route = route
    }
    
    func navigate(to shop: Shop) {
        navigate(to: .shop(shop))
    }
    
    public enum Route: Hashable, Identifiable {
        case shop(Shop)
        
        public var id: Self { self }
    }
}

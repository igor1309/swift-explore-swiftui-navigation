//
//  ShopGridViewModel.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation

public final class ShopGridViewModel: ObservableObject {

    @Published var route: Route?
    
    let shops: Shops

    public init(
        shops: Shops,
        route: Route? = nil
    ) {
        self.shops = shops
        self.route = route
    }
    
    func navigate(to shop: Shop) {
        route = .shop(shop)
    }
    
    public enum Route: Hashable, Identifiable {
        case shop(Shop)
        
        public var id: Self { self }
    }
}

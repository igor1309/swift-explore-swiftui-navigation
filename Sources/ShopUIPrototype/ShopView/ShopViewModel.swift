//
//  ShopViewModel.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation

public final class ShopViewModel: ObservableObject {
    
    @Published var route: Route?
    
    let shop: Shop
    
    public init(shop: Shop, route: Route? = nil) {
        self.shop = shop
        self.route = route
    }
    
    public enum Route: Hashable, Identifiable {
        case category(Category)
        case product(Product)
        
        public var id: Self { self }
    }
}

extension ShopViewModel: Hashable {
    
    public static func == (lhs: ShopViewModel, rhs: ShopViewModel) -> Bool {
        lhs === rhs
    }
    
    public func hash (into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

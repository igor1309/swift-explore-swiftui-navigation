//
//  File.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Foundation

public final class CategoryStripViewModel: ObservableObject {
    
    @Published var route: Route?
    
    let categories: Categories
    
    public init(categories: Categories, route: Route? = nil) {
        self.categories = categories
        self.route = route
    }
    
    func navigate(to category: Category) {
        route = .category(category)
    }
    
    public enum Route: Hashable, Identifiable {
        case category(Category)
        
        public var id: Self { self }
    }
}

//
//  ShopView.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import SwiftUI
import SwiftUINavigation

public struct ShopView: View {
    
    @ObservedObject private var viewModel: ShopViewModel
    
    public init(viewModel: ShopViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                TBD("Order in flight if any")
                
                DeliveryTypePicker(deliveryType: .constant(.all))
                    .padding(.horizontal)
                
                TBD("Quick Menu: discounts/catalogue/bought before")
                TBD("Rotating Promo strip: collections of goods")
                TBD("Select goods: hero cards")
                
                TBD("List of select categories")
                TBD("Link to catalogue (full list of categories)")
            }
        }
        .searchable(text: .constant(""))
        .navigationTitle(viewModel.shop.title)
        .navigationDestination(unwrapping: $viewModel.route) { route in
            switch route.wrappedValue {
            case let .category(category):
                Text("TBD: \"\(category.title)\" category view")
                
            case let .product(product):
                Text("TBD: \"\(product.title)\" product view")
            }
        }
    }
}

struct ShopView_Previews: PreviewProvider {
    
    private typealias Route = ShopViewModel.Route
    
    private static func shopView(route: Route? = nil) -> some View {
        NavigationStack {
            ShopView(
                viewModel: .init(
                    shop: .preview,
                    route: route
                )
            )
        }
    }
    
    static var previews: some View {
        Group {
            shopView()
            shopView(route: .category(.preview))
            shopView(route: .product(.preview))
        }
        .preferredColorScheme(.dark)
    }
}

#if DEBUG
public extension Category {
    
    static let preview: Self = .grocery
    static let grocery: Self = .init(title: "Grocery")
}

public extension Product {
    static let preview: Self = .init(title: "Milk", category: .grocery)
}
#endif

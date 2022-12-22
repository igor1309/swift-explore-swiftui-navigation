//
//  ShopGridView.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import IdentifiedCollections
import SwiftUI
import SwiftUINavigation

public typealias Shops = IdentifiedArrayOf<Shop>

public struct ShopGridView<ShopView: View>: View {
    
    @ObservedObject private var viewModel: ShopGridViewModel
    
    private let shopView: (Shop) -> ShopView
    
    public init(
        viewModel: ShopGridViewModel,
        shopView: @escaping (Shop) -> ShopView
    ) {
        self.viewModel = viewModel
        self.shopView = shopView
    }
    
    public var body: some View {
        LazyVGrid(columns: [.init(), .init()]) {
            ForEach(viewModel.shops, content: shopTileView)
        }
        .navigationDestination(
            unwrapping: .init(
                get: { viewModel.route },
                set: { viewModel.navigate(to: $0) }
            )
        ) { route in
            switch route.wrappedValue {
            case let .shop(shop):
                shopView(shop)
            }
        }
    }
    
    private func shopTileView(shop: Shop) -> some View {
        Color.orange
            .aspectRatio(1, contentMode: .fill)
            .overlay {
                Text(shop.title)
                    .font(.headline)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.navigate(to: shop)
            }
    }
}

struct ShopGridView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                ShopGridView(
                    viewModel: .init(
                        shops: .preview
                    )
                ) { shop in
                    VStack {
                        NavigationStack {
                            VStack {
                                Text("Shop View for shop with ID \(shop.id.rawValue.uuidString)")
                                    .foregroundColor(.secondary)
                                    .font(.footnote)
                                
                                Spacer()
                            }
                            .navigationTitle("Shop Name")
                        }
                    }
                }
                .padding()
            }
        }
    }
}

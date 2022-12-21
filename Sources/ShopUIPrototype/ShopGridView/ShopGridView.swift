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

public struct ShopGridView: View {
    
    @ObservedObject private var viewModel: ShopGridViewModel
    
    public init(viewModel: ShopGridViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        LazyVGrid(columns: [.init(), .init()]) {
            ForEach(viewModel.shops, content: shopTileView)
        }
        .navigationDestination(unwrapping: $viewModel.route) { route in
            switch route.wrappedValue {
            case let .shop(shop):
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
        }
    }
    private func shopTileView(shop: Shop) -> some View {
        Color.orange
            .aspectRatio(1, contentMode: .fill)
            .overlay {
                Text(shop.id.rawValue.uuidString.prefix(8))
                    .font(.caption)
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
                )
                .padding()
            }
        }
    }
}

#if DEBUG
public extension Shops {
    
    static let preview: Self = .init(uniqueElements: [Shop].preview)
}

private extension Array where Element == Shop {
    
    static let preview: Self = (0..<17).map { _ in .init() }
}
#endif

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
#warning("move to sample data in Domain")
    static let preview: Self = [
        .preview,
        .init(title: "Е-Аптека", category: .farmacy),
        .init(title: "Ашан", category: .hyper),
        .init(title: "Лента", category: .hyper),
        .init(title: "Магнит", category: .hyper),
        .init(title: "Пятерочка", category: .hyper),
        .init(title: "Перекресток", category: .hyper),
        .init(title: "Вкусвил", category: .hyper),
        .init(title: "Технопарк", category: .gadgets),
        .init(title: "Бетховен", category: .zoo),
        .init(title: "Зоогалерея", category: .zoo),
        .init(title: "Столетов", category: .farmacy),
        .init(title: "Твой дом", category: .house),
        .init(title: "Улыбка радуги", category: .house),
        .init(title: "Интернет аптека", category: .farmacy),
        .init(title: "Мосцветторг", category: .flower),
        .init(title: "Мр. Букет", category: .flower),
    ]
}
#endif

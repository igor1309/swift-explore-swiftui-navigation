//
//  ShopGridView.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import IdentifiedCollections
import SwiftUI

public typealias Shops = IdentifiedArrayOf<Shop>

struct ShopGridView: View {
    
    let shops: Shops
    
    var body: some View {
        LazyVGrid(columns: [.init(), .init()]) {
            ForEach(shops, content: shopView)
        }
    }
    
    private func shopView(shop: Shop) -> some View {
        Color.orange
            .aspectRatio(1, contentMode: .fill)
            .overlay {
                Text(shop.id.rawValue.uuidString.prefix(8))
                    .font(.caption)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct ShopGridView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                ShopGridView(shops: .preview)
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

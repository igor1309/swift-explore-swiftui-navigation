//
//  PromoStrip.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import IdentifiedCollections
import SwiftUI

public typealias Promos = IdentifiedArrayOf<Promo>

struct PromoStrip<PromoView: View>: View {
    
    let promos: Promos
    let promoView: (Promo) -> PromoView
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(promos, content: promoView)
            }
        }
    }
}

struct PromoStrip_Previews: PreviewProvider {
    static var previews: some View {
        PromoStrip(promos: .preview) { promo in
            Text(promo.id.rawValue.uuidString)
                .font(.caption)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
        }
    }
}

#if DEBUG
public extension IdentifiedArrayOf where Element == Promo, ID == Promo.ID {
    
    static let preview: Self = .init(uniqueElements: [Promo].preview)
}

private extension Array where Element == Promo {
    
    static let preview: Self = [
        .init(), .init(), .init(), .init(), .init(), .init()
    ]
}
#endif

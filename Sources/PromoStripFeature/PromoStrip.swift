//
//  PromoStrip.swift
//  
//
//  Created by Igor Malyarov on 21.12.2022.
//

import Domain
import SwiftUI

public struct PromoStrip<PromoView: View>: View {
    
    private let promos: Promos
    private let promoView: (Promo) -> PromoView
    
    public init(
        promos: Promos,
        promoView: @escaping (Promo) -> PromoView
    ) {
        self.promos = promos
        self.promoView = promoView
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(promos, content: promoView)
            }
            .padding(.horizontal)
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
